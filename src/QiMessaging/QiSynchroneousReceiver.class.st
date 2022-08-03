"
I am a blocking QiReceiver.

I block the execution of the the server loop until receiveMessage have been called.

Inversally, I the execution of receiveMessage waits for a new message to arrive.
"
Class {
	#name : #QiSynchroneousReceiver,
	#superclass : #QiReceiver,
	#instVars : [
		'signal',
		'message',
		'messageLock',
		'error'
	],
	#category : #'QiMessaging-Core'
}

{ #category : #initialization }
QiSynchroneousReceiver >> initialize [
	messageLock := Mutex new.
	signal := Semaphore new.
]

{ #category : #accessing }
QiSynchroneousReceiver >> receive: aQiMessage from: aQiChannel [
	messageLock critical: [
		message ifNil: [
			message := aQiMessage.
			signal signal.
			^self
			]
	].
	signal wait.
	self receive: aQiMessage from:aQiChannel.
]

{ #category : #accessing }
QiSynchroneousReceiver >> receiveMessage [
	messageLock critical: [ 
		| msg |
		error ifNotNil: [ ^ error signal ].
		message ifNotNil: [
			msg := message.
			message := nil.
			signal signal.
			^ msg ].
		].
	"At this stage there was no message, waiting..."
	signal wait.
	^ self receiveMessage
]

{ #category : #'stop conditions' }
QiSynchroneousReceiver >> stop: anError [
	messageLock critical: [ error := anError ].
	signal signal.
]
