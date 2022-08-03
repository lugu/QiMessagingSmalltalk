Class {
	#name : #QiResponseReceiverTest,
	#superclass : #QiReceiverTest,
	#category : #'QiMessaging-Tests'
}

{ #category : #tests }
QiResponseReceiverTest >> testSendReceive [
	{ self message1. self message2 } do: [ :expectedMessage |
		 | receiver |
		receiver := QiResponseReceiver new
		service: expectedMessage service;
		object: expectedMessage object;
		action: expectedMessage action;
		id: expectedMessage id.

		receiver receive: self message1 from: chan1.
		receiver receive: self message2 from: chan1.

		self assert: receiver receiveMessage equals: expectedMessage.
	]
]
