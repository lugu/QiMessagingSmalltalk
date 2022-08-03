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
		'socket',
		'url'
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

{ #category : #'initialize - destroy' }
QiChannel >> closeAndDestroy [
	socket closeAndDestroy
]

{ #category : #accessing }
QiChannel >> connect: aString [
	"Establish a connection to the service directory"
	"aString should be formatted like: tcp://<host>:<port>"	
	url := ZnUrl fromString: aString.
	"(url scheme) equals: 'tcp' ifFalse: "
	socket := Socket newTCP.
	socket connectToHostNamed: url host port: url port.
]

{ #category : #accessing }
QiChannel >> initializeSocket: aSocket withUrl: aString [ 
	socket := aSocket.
	url := aString.
]

{ #category : #accessing }
QiChannel >> isConnected [ 
	^ socket isConnected.
]

{ #category : #accessing }
QiChannel >> receiveHeader [
	"returns a QiMessage with only the header or raise an exception if something bad happend."
	| buffer len |
	buffer := ByteArray new: 28.
	len := socket receiveDataInto: buffer.
	len < 28 ifTrue:
		[ ^ Error new signal: 'Not yet supported: splitted header'].
	^ QiMessage fromHeader: buffer.
]

{ #category : #accessing }
QiChannel >> receiveMessage [
	"returns a QiMessage or nil after the timeout."
	| buffer message len |
	message := self receiveHeader.
	message size > QiMessage maxSize
		ifTrue: [ ^Error new signal: 'Message too large' ].
	buffer := ByteArray new: message size.
	len := socket receiveDataInto: buffer.
	len < message size ifTrue: [ ^ Error new signal: 'splitted payload'].
	message payload: buffer.
	^ message
]

{ #category : #accessing }
QiChannel >> sendMessage: aQiMessage [
	"Send a message to the other end of the channel."
	socket sendSomeData: aQiMessage data.
]

{ #category : #accessing }
QiChannel >> url [ 
	^ self url.
]
