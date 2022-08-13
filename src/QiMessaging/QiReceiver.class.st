"
I am the abstract interface to which QiMessage are sent.
"
Class {
	#name : #QiReceiver,
	#superclass : #Object,
	#category : #'QiMessaging-Core'
}

{ #category : #accessing }
QiReceiver >> receive: aQiMessage from: aQiChannel [
	^ SubclassResponsibility new signal
]

{ #category : #'stop conditions' }
QiReceiver >> stop: anError [
	^ SubclassResponsibility new signal
]
