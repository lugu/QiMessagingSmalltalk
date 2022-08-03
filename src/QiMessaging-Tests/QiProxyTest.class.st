Class {
	#name : #QiProxyTest,
	#superclass : #QiTestCase,
	#category : #'QiMessaging-Tests'
}

{ #category : #tests }
QiProxyTest >> demoProxyCallServer [

	"Integration test: connect to a remote server and start authentication"

	| url proxy capabilityMap response channel |

	url := 'tcp://localhost:9559'.
	capabilityMap := Dictionary newFrom: {
			                 ('auth_user' -> (QiValue newString: 'nao')).
			                 ('auth_token' -> (QiValue newString: 'nao')) }.

	channel := QiChannel connect: url.
	channel startPolling.
	[
	proxy := QiProxyObject new: channel
		         serviceId: 0
		         objectId: 0
		         metaObject: QiMetaObject authenticationService.

	response := proxy authenticate: capabilityMap.
	self assert: (response isKindOf: Dictionary) ] ensure: [
		channel stopPolling.
		channel close ]
]
