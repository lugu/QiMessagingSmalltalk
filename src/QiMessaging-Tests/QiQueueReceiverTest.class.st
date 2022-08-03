Class {
	#name : #QiQueueReceiverTest,
	#superclass : #QiReceiverTest,
	#category : #'QiMessaging-Tests'
}

{ #category : #tests }
QiQueueReceiverTest >> testSendReceive [ 
	| receiver message |
	receiver := QiQueueReceiver new.
	[
	 	receiver receive: self message1 from: chan1.
	 	receiver receive: self message1 from: chan1.
	 ] fork.
	message := receiver receiveMessage.
	message := receiver receiveMessage.
	self assert: message equals: self message1.
]
