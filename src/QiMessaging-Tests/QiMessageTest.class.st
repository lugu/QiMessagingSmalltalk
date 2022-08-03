Class {
	#name : #QiMessageTest,
	#superclass : #QiTestCase,
	#category : #'QiMessaging-Tests'
}

{ #category : #tests }
QiMessageTest >> testEquals [
	"test the creation of a QiMessage"
	self assert: (self message1 equals: self message1) equals: true.
	self assert: (self message1 equals: self message2) equals: false.
]

{ #category : #tests }
QiMessageTest >> testQiMessageCreation [
	"test the creation of a QiMessage"
	| message |
	message := QiMessage new id: 1; service: 2; object: 3; action: 4; payload: 'Hello world' asByteArray.
	self assert: message id equals: 1.
	self assert: message service equals: 2.
	self assert: message object equals: 3.
	self assert: message action equals: 4.
	self assert: message payload equals: 'Hello world' asByteArray.
]

{ #category : #tests }
QiMessageTest >> testQiMessageSerialization [
	"test the creation of a QiMessage"
	| expectedMessage bytes resultMessage |
	expectedMessage := QiMessage new id: 1;
		flags: 1; type: 2; service: 3; object: 4; action: 4; payload: 'Hello world' asByteArray.
	bytes := expectedMessage data.
	resultMessage := QiMessage createFromBytes: expectedMessage data.
	self assert: resultMessage id equals: expectedMessage id.
	self assert: resultMessage type equals: expectedMessage type.
	self assert: resultMessage flags equals: expectedMessage flags.
	self assert: resultMessage service equals: expectedMessage service.
	self assert: resultMessage object equals: expectedMessage object.
	self assert: resultMessage action equals: expectedMessage action.
	self assert: resultMessage payloadSize equals: expectedMessage payloadSize.
	self assert: resultMessage payload equals: expectedMessage payload.
]
