"
I reprensent a network server waiting for incomming connection.

When a client connects, I create a QiChannel and send it a QiService.
"
Class {
	#name : #QiServer,
	#superclass : #Object,
	#instVars : [
		'socket',
		'isRunning',
		'isRunningLock',
		'serviceDictionary'
	],
	#category : #'QiMessaging-Core'
}

{ #category : #internal }
QiServer >> handleConnection: aSocket [
	| chan |
	chan := QiChannel fromSocket: aSocket withUrl: 'client connection'.
	[
		[ self isRunning ] whileTrue: 
			[
				[ self receive: chan receiveMessage from: chan ]
				on: Error do: [ :anError |
					chan close.
					anError trace.
					^anError. ]
			]
	] ensure: [ aSocket closeAndDestroy ]
]

{ #category : #initialization }
QiServer >> initialize [
	super initialize.
	isRunningLock := Mutex new.
	isRunning := false.
	serviceDictionary := Dictionary new.
]

{ #category : #internal }
QiServer >> interactOnConnection [
	| sessionSocket |
	sessionSocket := socket 	waitForAcceptFor: 	1 ifTimedOut: [ ^self ].
	[ self handleConnection: sessionSocket ] fork
]

{ #category : #accessing }
QiServer >> isRunning [
	^ isRunningLock critical: [ ^ isRunning ]
]

{ #category : #internal }
QiServer >> isRunning: aBoolean [
	isRunningLock critical: [ isRunning := aBoolean ]	
]

{ #category : #internal }
QiServer >> receive: aQiMessage from: aQiChannel [
	serviceDictionary at: aQiMessage service
	ifPresent: [ :service | service receive: aQiMessage from: aQiChannel ]
	ifAbsent: [ aQiChannel sendMessage: (QiMessage serviceNotFound: aQiMessage)]
]

{ #category : #internal }
QiServer >> serve [
		[
			[ self isRunning ] whileTrue: [ self interactOnConnection ]
		] ensure:
			[ socket closeAndDestroy ].
		^ self
]

{ #category : #accessing }
QiServer >> service: aQiService id: aNumber [
	serviceDictionary at: aNumber put: aQiService
]

{ #category : #initialize }
QiServer >> socket: aSocket [
	socket := aSocket
]

{ #category : #accessing }
QiServer >> start [
	isRunningLock critical: [ 
		self isRunning ifTrue: [ ^ self ].
		self isRunning: true ].
	self assert: socket notNil.
	[ self serve ] fork.
	^ self
]

{ #category : #accessing }
QiServer >> stop [
	self isRunning: false.
	^ self
]
