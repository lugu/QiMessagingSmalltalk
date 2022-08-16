Class {
	#name : #QiProxyObjectTest,
	#superclass : #QiTestCase,
	#category : #'QiMessaging-Tests'
}

{ #category : #tests }
QiProxyObjectTest >> demoProxyCallServer [

	"Integration test: connect to a remote server and start authentication"

	| url proxy capabilityMap response channel |

	url := 'tcp://localhost:9559'.
	capabilityMap := Dictionary newFrom: {
			                 ('auth_user' -> (QiValue newString: 'nao')).
			                 ('auth_token' -> (QiValue newString: 'nao')) }.

	channel := QiChannel connect: url.
	channel startPolling.
	[
	proxy := QiProxyObject newWithName: 'AuthenticationService'
					channel: channel
		         serviceId: 0
		         objectId: 0
		         metaObject: QiMetaObject authenticationService.

	response := proxy authenticate: capabilityMap.
	self assert: (response isKindOf: Dictionary) ] ensure: [
		channel stopPolling.
		channel close ]
]

{ #category : #tests }
QiProxyObjectTest >> demoSignalSubscription [

	"Integration test: connect to a remote server and listen to a signal"
	| session cancelable |
	session := QiSession new join: 'tcp://localhost:9559'.
	session directory enableTrace: true.
	cancelable := session directory onTraceObjectDo: [ :each | 'Yeah' traceCr ].
	10 timesRepeat: [ session directory services ].
	cancelable cancel.
	cancelable inspect.
]

{ #category : #tests }
QiProxyObjectTest >> testAuthenticationServiceClassCreation [
	| object | 
	Smalltalk
		at: #QimProxyAuthenticationService
		ifPresent: [ :aClass | aClass removeFromSystem ].

	object := QiProxyObject newWithName: 'AuthenticationService'
					channel: chan1
		         serviceId: 0
		         objectId: 0
		         metaObject: QiMetaObject authenticationService.

	Smalltalk
		at: #QimProxyAuthenticationService
		ifAbsent: [ self fail: 'Missing class' ].
]

{ #category : #tests }
QiProxyObjectTest >> testBasicObjectCreation [

	| object |
	"Remove QimProxyBasicObject before creation and test recreation"
	Smalltalk
		at: #QimProxyBasicObject
		ifPresent: [ :aClass | aClass removeFromSystem ].

	object := QiProxyObject
		          newBasicObject: chan1
		          serviceId: 0
		          objectId: 0.

	Smalltalk
		at: #QimProxyBasicObject
		ifAbsent: [ self fail: 'Missing class' ].

	object := QiProxyObject
		          newBasicObject: chan1
		          serviceId: 0
		          objectId: 0
]

{ #category : #tests }
QiProxyObjectTest >> testSignalSubscription [

	"Integration test: connect to a remote server and listen to a signal"
	| session cancelable |
	session := QiSession new join: 'tcp://localhost:9559'.
	session directory enableTrace: true.
	cancelable := session directory onTraceObjectDo: [ :each | each traceCr. ].
	10 timesRepeat: [ session directory services ].
	cancelable cancel.
]
