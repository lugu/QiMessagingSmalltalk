"
I represents a connection to the QiMessaging bus.

I maintain a network connect to the service directory for the duration of the session. I manage all the network connections to the various services. I close all connections when a disconnection to the service directory occurs.

To connect to the service directory, I need an URL of the form 'tcp://<host>:<port'. I facilitate connections to services with the help of QiServiceDirectory.

Public API and Key Messages

•	connectTo: anUrl
•	terminate


Example:

QiBus new
connectTo: 'tcp://localhost:9559'.
yourself.

Only supports the 'tcp' scheme. The 'tcps' scheme using TLS is not supported.
"
Class {
	#name : #QiBus,
	#superclass : #Object,
	#instVars : [
		'channelDictionary',
		'serviceDirectoryChannel'
	],
	#classInstVars : [
		'serviceDirectorySocket'
	],
	#category : #'QiMessaging-Core'
}

{ #category : #'instance creation' }
QiBus class >> create: aString [
	"Creates a new bus and contect the URL"
	| bus |
	bus := self new.
	bus initializeServiceDirectory: aString.
	^bus.
]

{ #category : #accessing }
QiBus >> connect: aString [
	"Establish a connection to a service (or reusing existing connection)."
	"aString should be formatted like: tcp://<host>:<port>"	
	| channel |
	^ channelDictionary at: aString ifAbsent: [ 
		channel := QiChannel connect: aString.
		channelDictionary at: aString put: channel.
		^ channel ]

]

{ #category : #initialization }
QiBus >> initialize [ 
	super initialize.
	channelDictionary := Dictionary new.
]

{ #category : #initialize }
QiBus >> initializeServiceDirectory: aString [
	serviceDirectoryChannel := QiChannel connect: aString.
	channelDictionary at: aString put: serviceDirectoryChannel.
]

{ #category : #accessing }
QiBus >> isConnected [
	"Return true if the connection to the service directory is established"
	^ serviceDirectoryChannel isConnected.
]
