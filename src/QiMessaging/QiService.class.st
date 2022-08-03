"
I represents a service on the bus.

I forward incomming messages to the QiObjects I own.
"
Class {
	#name : #QiService,
	#superclass : #QiReceiver,
	#instVars : [
		'objectDictionary'
	],
	#category : #'QiMessaging-Core'
}

{ #category : #initialization }
QiService >> initialize [
	super initialize.
	objectDictionary := Dictionary new.
]

{ #category : #accessing }
QiService >> receive: aQiMessage from: aQiChannel [
	objectDictionary at: aQiMessage object
	ifPresent: [ :object | object receive: aQiMessage from: aQiChannel ]
	ifAbsent: [ aQiChannel sendMessage: (QiMessage objectNotFound: aQiMessage)]
	
]
