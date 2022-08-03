Class {
	#name : #QiTestCase,
	#superclass : #TestCase,
	#instVars : [
		'chan1',
		'chan2'
	],
	#category : #'QiMessaging-Tests'
}

{ #category : #accessing }
QiTestCase >> chan1 [

	^ chan1
]

{ #category : #accessing }
QiTestCase >> chan2 [

	^ chan2
]

{ #category : #helpers }
QiTestCase >> listenerAddress1 [
	^NetNameResolver localAddressString
]

{ #category : #helpers }
QiTestCase >> listenerAddressUrl1 [
	"Returns a String representing the URL."
	|url|
	url := ZnUrl new scheme: 'tcp'; host: self listenerAddress1; port: self listenerPort1.
	^String streamContents: [ :stream | url printOn: stream ]
]

{ #category : #helpers }
QiTestCase >> listenerAddressUrl2 [
	"Returns a String representing the URL."
	|url|
	url := ZnUrl new scheme: 'tcp'; host: self listenerAddress1; port: self listenerPort2.
	^String streamContents: [ :stream | url printOn: stream ]
]

{ #category : #helpers }
QiTestCase >> listenerHost1 [
	^'localhost'
]

{ #category : #helpers }
QiTestCase >> listenerHostUrl1 [
	"Returns a String representing the URL."
	|url|
	url := ZnUrl new scheme: 'tcp'; host: self listenerHost1; port: self listenerPort1.
	^String streamContents: [ :stream | url printOn: stream ]
]

{ #category : #helpers }
QiTestCase >> listenerHostUrl2 [
	"Returns a String representing the URL."
	|url|
	url := ZnUrl new scheme: 'tcp'; host: self listenerHost1; port: self listenerPort2.
	^String streamContents: [ :stream | url printOn: stream ]
]

{ #category : #helpers }
QiTestCase >> listenerPort1 [
	^42324
]

{ #category : #helpers }
QiTestCase >> listenerPort2 [
	^self listenerPort1+1
]

{ #category : #helpers }
QiTestCase >> listenerSocket1 [
	^ Socket newTCP listenOn: self listenerPort1 backlogSize: 10.
]

{ #category : #helpers }
QiTestCase >> listenerSocket2 [
	^ Socket newTCP listenOn: self listenerPort2 backlogSize: 10. 
]

{ #category : #helpers }
QiTestCase >> message1 [
	^ QiMessage new id: 7; flags: 8; type: 9; service: 10; object: 11; action: 12; payload: 'Something else' asByteArray.
]

{ #category : #helpers }
QiTestCase >> message2 [
	^ QiMessage new id: 2; service: 3; object: 4; action: 5; payload: 'Something else' asByteArray.
]

{ #category : #running }
QiTestCase >> setUp [
	"Create a pair of channels"
	| serverSocket  sessionSocket |
	super setUp.
	serverSocket := self listenerSocket1.
	chan1 := QiChannel connect: self listenerHostUrl1.
	sessionSocket := serverSocket
		                 waitForAcceptFor: 1
		                 ifTimedOut: [ ^ self ].
	chan2 := QiChannel
		                fromSocket: sessionSocket
		                withUrl: 'session socket'.
]

{ #category : #running }
QiTestCase >> tearDown [
	chan1 close.
	chan2 close.
	super tearDown
]
