"
A QiServerTest is a test class for testing the behavior of QiServer
"
Class {
	#name : #QiServerTest,
	#superclass : #QiTestCase,
	#category : #'QiMessaging-Tests'
}

{ #category : #tests }
QiServerTest >> testConcurentClients [
	| socket semaphore server |
	socket := self listenerSocket1.
	semaphore := Semaphore new.
	[
		server := QiServer new socket: socket.
		server start.
		20 timesRepeat: [
			[
				[
					| channel message |
					channel := QiChannel new connect: self listenerAddressUrl1.
					channel sendMessage: self message1.
					message := channel receiveMessage.
					self assert: message type equals: QiMessage typeError.
					channel close.
				] ensure: [ 	semaphore signal ]
			] fork.
		].
			
		20 timesRepeat: [ semaphore wait ].
		server stop.
		self assert: socket isConnected equals: false.
		
	] ensure: [ socket closeAndDestroy ]
]

{ #category : #tests }
QiServerTest >> testConnect [
	| socket server channel |
	socket := self listenerSocket1.
	[
		server := QiServer new socket: socket.
		server start.

		channel := QiChannel new connect: self listenerAddressUrl1.
		self assert: channel isConnected.
		
		server stop.
		self assert: server isRunning equals: false.
		"Wait the serve process to pickup the stop request"
		(Delay forSeconds: 1) wait.
		self assert: socket isConnected equals: false.
		
	] ensure: [ socket closeAndDestroy ]
]

{ #category : #tests }
QiServerTest >> testMultipleClients [
	| socket server |
	socket := self listenerSocket1.
	[
		server := QiServer new socket: socket.
		server start.

		20 timesRepeat: [
			| channel message |
			channel := QiChannel new connect: self listenerAddressUrl1.
			channel sendMessage: self message1.
			message := channel receiveMessage.
			self assert: message type equals: QiMessage typeError.
			channel close.
		].
		server stop.
		
		self assert: socket isConnected equals: false.
		
	] ensure: [ socket closeAndDestroy ]
]

{ #category : #tests }
QiServerTest >> testSend [
	| socket server channel |
	socket := self listenerSocket1.
	[
		server := QiServer new socket: socket.
		server start.

		channel := QiChannel new connect: self listenerAddressUrl1.
		channel sendMessage: self message1.
		
		server stop.
		self assert: server isRunning equals: false.
		"Wait the serve process to pickup the stop request"
		(Delay forSeconds: 1) wait.
		self assert: socket isConnected equals: false.
		
	] ensure: [ socket closeAndDestroy ]
]

{ #category : #tests }
QiServerTest >> testSingleClient [
	| socket server channel message |
	socket := self listenerSocket1.
	[
		server := QiServer new socket: socket.
		server start.

		channel := QiChannel new connect: self listenerAddressUrl1.
		channel sendMessage: self message1.
		message := channel receiveMessage.
		self assert: message type equals: QiMessage typeError.
		channel close.		
		server stop.
		self assert: socket isConnected equals: false.
		
	] ensure: [ socket closeAndDestroy ]
]

{ #category : #tests }
QiServerTest >> testStartStop [

	| server socket |
	socket := self listenerSocket1.
	[ 
		server := QiServer new socket: socket.
		server start.
		self assert: server isRunning equals: true.
		server stop.
		self assert: socket isConnected equals: false.
	] ensure: [ socket closeAndDestroy ].
]
