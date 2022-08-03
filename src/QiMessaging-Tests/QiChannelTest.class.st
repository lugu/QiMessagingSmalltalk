Class {
	#name : #QiChannelTest,
	#superclass : #QiTestCase,
	#category : #'QiMessaging-Tests'
}

{ #category : #tests }
QiChannelTest >> testConnectAddress [
	"Connect using an URL like tcp://127.0.0.1:123"

| socket chan |
socket := self listenerSocket1. 
chan := QiChannel connect: self listenerAddressUrl1.
self assert: chan isConnected.

]

{ #category : #tests }
QiChannelTest >> testConnectHost [
	"Connect using an URL like tcp://localhost:123"

| socket chan |
socket := self listenerSocket1. 
chan := QiChannel connect: self listenerHostUrl1.
self assert: chan isConnected.
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
QiChannelTest >> testSendReceive [

	"Send and receive data via a channel"

	| serverSocket chanSender chanReceiver sessionSocket message |
	serverSocket := self listenerSocket1.
	message := [ 
	           chanSender := QiChannel connect: self listenerHostUrl1.
	           sessionSocket := serverSocket
		                            waitForAcceptFor: 1
		                            ifTimedOut: [ ^ self ].
	           [ 
	           self assert: chanSender isConnected equals: true.
	           chanSender sendMessage: self message1.
	           chanReceiver := QiChannel fromSocket: sessionSocket withUrl: 'session socket'.
	           chanReceiver receiveMessage ] ensure: [ 
		           sessionSocket closeAndDestroy.
		           self assert: sessionSocket isConnected equals: false ] ] 
		           ensure: [ 
			           serverSocket closeAndDestroy.
			           self assert: serverSocket isConnected equals: false ].
	self assert: (message equals: self message1).
]
