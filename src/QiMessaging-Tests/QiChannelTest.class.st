Class {
	#name : #QiChannelTest,
	#superclass : #QiTestCase,
	#category : #'QiMessaging-Tests'
}

{ #category : #tests }
QiChannelTest >> testConnectAddress [
	"Connect using an URL like tcp://127.0.0.1:123"
	self assert: self chan1 isConnected.
	chan1 close.
	self assert: self chan1 isConnected equals: false.

]

{ #category : #tests }
QiChannelTest >> testConnectHost [
	"Connect using an URL like tcp://localhost:123"

| socket chan |
socket := self listenerSocket1. 
chan := QiChannel connect: self listenerHostUrl1.
self assert: chan isConnected.
chan close.
self assert: chan isConnected equals: false.

]

{ #category : #tests }
QiChannelTest >> testOpenClose [
	"Connect using an URL like tcp://localhost:123"
	| serverSocket chanSender sessionSocket |

	serverSocket := self listenerSocket1. 
	chanSender := QiChannel connect: self listenerHostUrl1.
	sessionSocket := serverSocket 	waitForAcceptFor: 	1 ifTimedOut: [ ^self ].
	self assert: chanSender isConnected equals: true.
	sessionSocket closeAndDestroy.
	self assert: sessionSocket isConnected equals: false.
	(Delay forMilliseconds: 100) wait.
	serverSocket closeAndDestroy.
	self assert: serverSocket isConnected equals: false.
	
]

{ #category : #tests }
QiChannelTest >> testPollingStartStop [

	"Send and receive data via a channel"

	chan1 startPolling.
	chan1 stopPolling.
]

{ #category : #tests }
QiChannelTest >> testPollingWith2QueueRececeivers [

	"Send and receive data via a channel"
	| receiver1 receiver2 message |
	receiver1 := QiQueueReceiver new.
	receiver2 := QiQueueReceiver new.

	self chan2 startPolling.
	
	self chan2 addReceiver: receiver1.
	self chan2 addReceiver: receiver2.

	self chan1 sendMessage: self message1.
	self chan1 sendMessage: self message2.

	message := receiver1 receiveMessage.
	self assert: message equals: self message1.
	message := receiver2 receiveMessage.
	self assert: message equals: self message1.

	message := receiver1 receiveMessage.
	self assert: message equals: self message2.
	message := receiver2 receiveMessage.
	self assert: message equals: self message2.

	chan2 stopPolling.
]

{ #category : #tests }
QiChannelTest >> testPollingWithQueueRececeivers [

	"Send and receive data via a channel"
	| receivers number |	
	receivers := Bag new.
	20 timesRepeat: [ receivers add: QiQueueReceiver new ].

	self chan2 startPolling.
	receivers do: [ :receiver | self chan2 addReceiver: receiver ].
	
	number := 1000.
	number timesRepeat: [ self chan1 sendMessage: self message1 ].

	receivers do: [ :receiver | 
		number timesRepeat: [
			| message |
			message := receiver receiveMessage.
			self assert: message equals: self message1 ] ].
	
	chan2 stopPolling
]

{ #category : #tests }
QiChannelTest >> testPollingWithRececeivers [

	"Send and receive data via a channel"
	| receiver1 receiver2 message |
	receiver1 := QiSynchroneousReceiver new.
	receiver2 := QiSynchroneousReceiver new.

	self chan2 startPolling.
	
	self chan2 addReceiver: receiver1.
	self chan2 addReceiver: receiver2.

	self chan1 sendMessage: self message1.
	self chan1 sendMessage: self message2.

	message := receiver1 receiveMessage.
	self assert: message equals: self message1.
	message := receiver2 receiveMessage.
	self assert: message equals: self message1.

	message := receiver1 receiveMessage.
	self assert: message equals: self message2.
	message := receiver2 receiveMessage.
	self assert: message equals: self message2.

	chan2 stopPolling.
]

{ #category : #tests }
QiChannelTest >> testPollingWithSynchroneousRececeivers [

	"Send and receive data via a channel"
	| receiver1 receiver2 message |
	receiver1 := QiSynchroneousReceiver new.
	receiver2 := QiSynchroneousReceiver new.

	self chan2 startPolling.
	
	self chan2 addReceiver: receiver1.
	self chan2 addReceiver: receiver2.

	self chan1 sendMessage: self message1.
	self chan1 sendMessage: self message2.

	message := receiver1 receiveMessage.
	self assert: message equals: self message1.
	message := receiver2 receiveMessage.
	self assert: message equals: self message1.

	message := receiver1 receiveMessage.
	self assert: message equals: self message2.
	message := receiver2 receiveMessage.
	self assert: message equals: self message2.

	chan2 stopPolling.
]

{ #category : #tests }
QiChannelTest >> testSend [

	"Send and receive data via a channel"

	self assert: chan1 isConnected equals: true.
	chan1 sendMessage: self message1.
]

{ #category : #tests }
QiChannelTest >> testSendReceive [

	"Send and receive data via a channel"
	| message |
	self assert: chan1 isConnected equals: true.
	chan1 sendMessage: self message1.
	message := chan2 receiveMessage.
	self assert: (message equals: self message1).

]

{ #category : #tests }
QiChannelTest >> testStartStopPolling [

	"Send and receive data via a channel"

	chan1 startPolling.	
	self assert: chan1 isPolling equals: true.
	chan1 stopPolling.
	self assert: chan1 isPolling equals: false.

	chan1 startPolling.	
	self assert: chan1 isPolling equals: true.
	chan1 startPolling.	
	self assert: chan1 isPolling equals: true.
	chan1 stopPolling.
	self assert: chan1 isPolling equals: false.
	chan1 stopPolling.
	self assert: chan1 isPolling equals: false.

]
