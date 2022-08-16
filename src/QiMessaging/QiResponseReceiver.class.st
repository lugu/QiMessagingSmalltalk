"
I am able to receive message with a specific message id.

I can receive one message (call / response) or several message (for signals).

I am bufferred and deliver messages in order.
"
Class {
	#name : #QiResponseReceiver,
	#superclass : #QiQueueReceiver,
	#instVars : [
		'service',
		'object',
		'action',
		'id'
	],
	#category : #'QiMessaging-Core'
}

{ #category : #accessing }
QiResponseReceiver >> action [

	^ action
]

{ #category : #accessing }
QiResponseReceiver >> action: anObject [
	action := anObject
]

{ #category : #accessing }
QiResponseReceiver >> id [

	^ id
]

{ #category : #accessing }
QiResponseReceiver >> id: anObject [

	id := anObject
]

{ #category : #accessing }
QiResponseReceiver >> object [

	^ object
]

{ #category : #accessing }
QiResponseReceiver >> object: anObject [

	object := anObject
]

{ #category : #accessing }
QiResponseReceiver >> receive: aQiMessage from: aQiChannel [
	(aQiMessage id = id and: [ 
		 aQiMessage service = service and: [ 
			 aQiMessage object = object and: [ aQiMessage action = action ] ] ]) 
		ifTrue: [ super receive: aQiMessage from: aQiChannel ]
]

{ #category : #accessing }
QiResponseReceiver >> service [

	^ service
]

{ #category : #accessing }
QiResponseReceiver >> service: anObject [

	service := anObject
]
