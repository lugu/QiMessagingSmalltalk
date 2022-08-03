"
I represents a permanent connection to the QiMessaging bus.

I need an URL of the form 'tcp://<host>:<port' to join the bus.

I initiate and cache the network connections to the various services.

I use the service directory service to discover other services.

I close all connections when disconnected to the service directory.

Public API and Key Messages

•	Initiate a connection to the bus
•	Create a proxy object fo a service
•	Set the username used for authentication
•	Set the token used for authentication

•	join: aString
•	service: aString
•	user: aString
•	token: aString


Example:

QiBus new
connectTo: 'tcp://localhost:9559'.
yourself.

Only supports the 'tcp' scheme. The 'tcps' scheme using TLS is not supported.
"
Class {
	#name : #QiSession,
	#superclass : #Object,
	#instVars : [
		'channels',
		'directory',
		'user',
		'token'
	],
	#category : #'QiMessaging-Core'
}

{ #category : #'instance creation' }
QiSession class >> create: aString [
	"Creates a new bus and contect the URL"
	| bus |
	bus := self new.
	bus initializeServiceDirectory: aString.
	^bus.
]

{ #category : #'instance creation' }
QiSession class >> machineId [
	"Unique identifier of machine used to decide which endpoint to connect to."
	"If the service has the same machine id, then the local addres can be find."
	^ '/etc/machine-id' asFileReference contents
]

{ #category : #accessing }
QiSession >> authenticate: aQiChannel [
	"Send the authenticate message to the Authentication service."
	| proxy capabilityMap response state |

	capabilityMap := Dictionary newFrom: {
			                 ('auth_user' -> (QiValue newString: user)).
			                 ('auth_token' -> (QiValue newString: token)) }.

	proxy := QiProxyObject new: aQiChannel
		         serviceId: 0
		         objectId: 0
		         metaObject: QiMetaObject authenticationService.

	response := proxy authenticate: capabilityMap.
	(response isKindOf:	QiError) ifTrue: [ ^response ].
	state := response at: '__qi_auth_state' ifAbsent: [ ^ QiError new: 'Missing __qi_auth_state' ].
	(state value = 3) ifFalse: [ ^ QiError new: 'Authentication failed with state ', state value asString ]
]

{ #category : #accessing }
QiSession >> channelFromServiceInfo: info [
	"Return a QiProxyObject representing the remote service aString."
	| isDifferentMachine |
	isDifferentMachine := info machineId = self machineId.
	^ info endpoints detect: [ :url |
			(isDifferentMachine and: [ url contains: '127.0.0.1']) ifTrue: [ false ]
			ifFalse: 	[[ self connect: url. true ] onErrorDo: [ false ]]
	].
]

{ #category : #'initialize - destroy' }
QiSession >> closeAllConnections [
	"Close all established connections."
	[ channels isNotEmpty ] whileTrue: [ 
		channels first close.
		channels remove: channels first ].
]

{ #category : #accessing }
QiSession >> connect: aString [
	"Establish a connection to a service (or reusing existing connection)."
	"aString should be formatted like: tcp://<host>:<port>"
	| channel |
	^ channels at: aString ifAbsent: [
		channel := QiChannel new connect: aString.
		channel startPolling.
		self authenticate: channel.
		channels at: aString put: channel.
		^ channel ]

]

{ #category : #initialization }
QiSession >> directory [
	^ directory

]

{ #category : #initialization }
QiSession >> directory: aQiChannel [
	"Returns a proxy object representing the Service Director"
	directory  := QiProxyObject new: aQiChannel
		         serviceId: 1
		         objectId: 1
		         metaObject: QiMetaObject basicObject.
	^ directory reify.
]

{ #category : #initialization }
QiSession >> initialize [
	super initialize.
	channels := Dictionary new.
	user := 'nao'.
	token := 'nao'.
]

{ #category : #accessing }
QiSession >> isConnected [
	"Return true if the connection to the service directory is established"
	^ directory isConnected.
]

{ #category : #accessing }
QiSession >> join: aString [
	"Create a new session. A session is a connection to the service directory."
	"Close all existing connections."
	self closeAllConnections.
	self directory: (self connect: aString).
]

{ #category : #accessing }
QiSession >> service: aString [
	"Return a QiProxyObject representing the remote service aString."
	| info chan service |
	info := directory service: aString.
	chan := self channelFromServiceInfo: info.
	service := QiProxyObject new: chan
		         serviceId: info serviceId
		         objectId: 1
		         metaObject: QiMetaObject basicObject.
	^ service reify

]

{ #category : #accessing }
QiSession >> token: aString [
	"Set the token used for authentication."
	token := aString
]

{ #category : #accessing }
QiSession >> user: aString [
	"Set the login used for authentication."
	user := aString
]
