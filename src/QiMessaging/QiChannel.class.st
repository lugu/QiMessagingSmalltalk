"
I represent a network connection.

I can send and receive QiMessages.

Instance Variables:
	socket:	<Socket>
	url:		<ZnUrl>
"
Class {
	#name : #QiChannel,
	#superclass : #Object,
	#instVars : [
		'url',
		'stream',
		'receivers',
		'receiversLock',
		'isPolling',
		'isPollingLock'
	],
	#category : #'QiMessaging-Core'
}

{ #category : #initialize }
QiChannel class >> connect: aString [
	"Create a new channel connected the URL"
	| chan |
	chan := self new.
	chan connect: aString.
	^chan.
]

{ #category : #initialize }
QiChannel class >> fromSocket: aSocket [
	"Create a new channel connected the URL"
	| chan |
	chan := self new.
	chan initializeSocket: aSocket.
	^chan.
]

{ #category : #initialize }
QiChannel class >> fromSocket: aSocket withUrl: aString [
	"Create a new channel connected the URL"
	| chan |
	chan := self new.
	chan initializeSocket: aSocket withUrl: aString.
	^chan.
]

{ #category : #accessing }
QiChannel >> addReceiver: aQiReceiver [
	receiversLock critical: [ 
		receivers add: aQiReceiver.
	]
]

{ #category : #'initialize - destroy' }
QiChannel >> close [
	stream close
]

{ #category : #'initialize - destroy' }
QiChannel >> connect: aString [
	"Establish a connection to the service directory"
	"aString should be formatted like: tcp://<host>:<port>"	
	| socket |
	url := ZnUrl fromString: aString.
	"(url scheme) equals: 'tcp' ifFalse: "
	socket := Socket newTCP.
	socket connectToHostNamed: url host port: url port.
	self initializeSocket: socket withUrl: aString.
]

{ #category : #accessing }
QiChannel >> fillBuffer: aByteArray [
	"returns a QiMessage or nil after the timeout."
	| size len |
	size := aByteArray size.
	len := stream readInto: aByteArray startingAt: 1 count: size.
	len < size ifTrue: [
		stream isConnected
			ifTrue: [ ^ Error new signal: 'unknown error']
			ifFalse: [ ^ Error new signal: 'socket closed'].
	]
]

{ #category : #initialization }
QiChannel >> initialize [
	receivers := Bag new.
	receiversLock := Mutex new.
	isPolling := false.
	isPollingLock := Mutex new.
]

{ #category : #'initialize - destroy' }
QiChannel >> initializeSocket: aSocket withUrl: aString [ 
	url := aString.
	stream := SocketStream on: aSocket.
	stream binary.
]

{ #category : #accessing }
QiChannel >> isConnected [ 
	^ stream isConnected.
]

{ #category : #'initialize - destroy' }
QiChannel >> isPolling [
	^ isPollingLock critical: [ ^ isPolling ]
]

{ #category : #internal }
QiChannel >> receiveHeader [
	"returns a QiMessage with only the header or raise an exception if something bad happend."
	| buffer |
	buffer := ByteArray new: 28.
	self fillBuffer: buffer.
	^ QiMessage fromHeader: buffer.
]

{ #category : #accessing }
QiChannel >> receiveMessage [
	"returns a QiMessage or nil after the timeout."
	| buffer message |
	message := self receiveHeader.
	"TODO: SocketStream has a limitation lower than maxSize."
	message size > QiMessage maxSize
		ifTrue: [ ^Error new signal: 'Message too large' ].
	buffer := ByteArray new: message size.
	self fillBuffer: buffer.
	message payload: buffer.
	^ message
]

{ #category : #internal }
QiChannel >> removeAllReceivers: anError [

	"Remove all receivers by sending them the stop message."

	receivers do: [ :each | each close: anError ].
	receivers removeAll.
]

{ #category : #accessing }
QiChannel >> removeReceiver: aQiReceiver [
	"The receiver will no more receive messages."
	"Message close: is sent with QiErrorStop"
	receiversLock critical: [
		receivers remove: aQiReceiver ifAbsent: [].
	].
	aQiReceiver stop: (QiErrorStop newString: 'receiver removed.').
]

{ #category : #accessing }
QiChannel >> sendMessage: aQiMessage [
	"Send a message to the other end of the channel."
	stream nextPutAllFlush: aQiMessage data.
]

{ #category : #'initialize - destroy' }
QiChannel >> startPolling [

	"Start a process which will send the incoming message to the QiReceivers"
	isPollingLock critical: [ 
		isPolling ifTrue: [ ^ self ]. "Prevent multiple polling loops"
		isPolling := true. ].
	[
	[ self isPolling ] whileTrue: [ 
		| msg |
		[
		msg := self receiveMessage.
		receiversLock critical: [ 
			receivers do: [ :receiver | receiver receive: msg from: self ] ] ]
			on: Error
			do: [ :anError |
				self close.
				isPollingLock critical: [ isPolling := false ].
				receiversLock critical: [ self removeAllReceivers: anError ]
				] ] ] fork.
]

{ #category : #'initialize - destroy' }
QiChannel >> stopPolling [
	"Stops the process which will send the incoming message to the QiReceivers"
	isPollingLock critical: [ isPolling := false ]
]

{ #category : #accessing }
QiChannel >> url [ 
	^ self url.
]
