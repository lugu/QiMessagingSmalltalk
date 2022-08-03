"
I test the QiSession class.

Tests:
- URL parsing
- Connection
- Terminaison
"
Class {
	#name : #QiSessionTest,
	#superclass : #QiTestCase,
	#category : #'QiMessaging-Tests'
}

{ #category : #tests }
QiSessionTest >> demoSession [
	| session logger |
	session := QiSession new join: 'tcp://localhost:9559'.
	logger := session service: 'LogManager'.
	logger inspect.
]

{ #category : #tests }
QiSessionTest >> testConnect [
	"Connect using an URL like tcp://127.0.0.1:123"

| socket socket2 session channel |
socket := self listenerSocket1.
socket2 := self listenerSocket2.
session := QiSession new connect: self listenerAddressUrl1.
channel := session connect: self listenerAddressUrl2.
self assert: session isConnected.
self assert: channel isConnected.
]

{ #category : #tests }
QiSessionTest >> testMultipleConnect [
	"Test that muliple connection to the same URL return the same channel"

	| socket socket2 session channel1 channel2 |
	socket := self listenerSocket1.
	socket2 := self listenerSocket2.
	session := QiSession new connect: self listenerAddressUrl1.
	channel1 := session connect: self listenerAddressUrl2.
	channel2 := session connect: self listenerAddressUrl2.
	self assert: channel1 identicalTo: channel2.
	self assert: session isConnected.
	self assert: channel1 isConnected
]

{ #category : #tests }
QiSessionTest >> testNew [
	"Connect using an URL like tcp://127.0.0.1:123"

| socket session |
socket := self listenerSocket1.
session := QiSession create: self listenerAddressUrl1.
self assert: session isConnected.
]
