"
I am a non blocking QiReceiver.

When I receive a message, I put it in a queue which is later consummed with receiveMessage.

I can be used to avoid blocking the server during the treatment of a message.
"
Class {
	#name : #QiQueueReceiver,
	#superclass : #QiReceiver,
	#instVars : [
		'queue',
		'queueLock',
		'signal',
		'error'
	],
	#category : #'QiMessaging-Core'
}

{ #category : #initialization }
QiQueueReceiver >> initialize [ 
	queueLock := Mutex new.
	queue := 	OrderedCollection new.
	signal := Semaphore new.
]

{ #category : #accessing }
QiQueueReceiver >> receive: aQiMessage from: aQiChannel [
	queueLock critical: [ queue addLast: { aQiMessage. aQiChannel } ].
	signal signal
]

{ #category : #accessing }
QiQueueReceiver >> receiveMessage [
	queueLock critical: [
		error ifNotNil: [ ^ error signal ].
		queue isNotEmpty ifTrue: [ 
			^ queue removeFirst first
		]
	].
	"At this stage there was no message, waiting..."
	signal wait.
	^ self receiveMessage
]

{ #category : #'stop conditions' }
QiQueueReceiver >> stop: anError [
	queueLock critical: [ error := anError ].
	signal signal.
]
