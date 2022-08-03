Class {
	#name : #QiSynchroneousReceiverTest,
	#superclass : #QiReceiverTest,
	#category : #'QiMessaging-Tests'
}

{ #category : #tests }
QiSynchroneousReceiverTest >> testSendReceive [ 
	| receiver message sequence |
	sequence := 'a'.
	receiver := QiSynchroneousReceiver new.
	[
		sequence := sequence, 'b'.
	 	receiver receive: self message1 from: chan1.
		sequence := sequence, 'c'.
	 	receiver receive: self message1 from: chan1.
		sequence := sequence, 'e'.
	 ] fork.
	message := receiver receiveMessage.
	sequence := sequence, 'd'.
	message := receiver receiveMessage.
	sequence := sequence, 'f'.
	self assert: message equals: self message1.
	self assert: sequence equals: 'abcdef'
]
