"
I test the QiBus class.

Tests:
- URL parsing
- Connection
- Terminaison
"
Class {
	#name : #QiBusTest,
	#superclass : #QiTestCase,
	#category : #'QiMessaging-Tests'
}

{ #category : #tests }
QiBusTest >> testConnect [
	"Connect using an URL like tcp://127.0.0.1:123"

| socket socket2 bus channel |
socket := self listenerSocket1.
socket2 := self listenerSocket2.
bus := QiBus create: self listenerAddressUrl1.
channel := bus connect: self listenerAddressUrl2.
self assert: bus isConnected.
self assert: channel isConnected.
]

{ #category : #tests }
QiBusTest >> testMultipleConnect [
	"Test that muliple connection to the same URL return the same channel"

	| socket socket2 bus channel1 channel2 |
	socket := self listenerSocket1.
	socket2 := self listenerSocket2.
	bus := QiBus create: self listenerAddressUrl1.
	channel1 := bus connect: self listenerAddressUrl2.
	channel2 := bus connect: self listenerAddressUrl2.
	self assert: channel1 identicalTo: channel2.
	self assert: bus isConnected.
	self assert: channel1 isConnected
]

{ #category : #tests }
QiBusTest >> testNew [
	"Connect using an URL like tcp://127.0.0.1:123"

| socket bus |
socket := self listenerSocket1. 
bus := QiBus create: self listenerAddressUrl1.
self assert: bus isConnected.
]
