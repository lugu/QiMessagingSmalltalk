"
I am a wrapper class around the MetaObject data returned by a QiObject.

I can find a method.
"
Class {
	#name : #QiMetaObject,
	#superclass : #Object,
	#instVars : [
		'methods',
		'signals',
		'properties',
		'description'
	],
	#category : #'QiMessaging-Core'
}

{ #category : #accessing }
QiMetaObject class >> authenticationService [
	^ self new
		description: 'Authentication serivce. I am a special service with only one method.';
		signals: Dictionary new;
		properties: Dictionary new;
		methods: (Dictionary newFrom: {
			0 -> (QiMetaMethod new
				uid: 8;
				returnSignature: '{sm}';
				name: 'authenticate';
				parametersSignature: '({sm})';
				description: 'authenticate negociate the __qi_auth_state';
				returnDescription: 'A CapabilityMap is returned with a __qi_auth_state value (1 for error, 2 to continue the negociation, 3 for success)';
				parameters: { (QiMetaMethodParameter new
					name: 'CapabilityMap';
					description: 'A map with the user_auth and auth_token values')
				}).
		})
]

{ #category : #accessing }
QiMetaObject class >> basicObject [
	^ self new
		description: 'I represent a object with the minimum methods and signals.';
		signals: Dictionary new;
		properties: Dictionary new;
		methods: (Dictionary newFrom: {
			0 -> (QiMetaMethod uid: 0 name: 'registerEvent' parameters: '(IIL)' return: 'L').
			1 -> (QiMetaMethod uid: 1 name: 'unregisterEvent' parameters: '(IIL)' return: 'v').
			2 -> (QiMetaMethod uid: 2 name: 'metaObject' parameters: '(I)' return: self metaObjectSignature).
			3 -> (QiMetaMethod uid: 3 name: 'terminate' parameters: '(I)' return: 'v').
			5 -> (QiMetaMethod uid: 5 name: 'property' parameters: '(m)' return: 'm').
			6 -> (QiMetaMethod uid: 6 name: 'setProperty' parameters: '(mm)' return: 'v').
			7 -> (QiMetaMethod uid: 7 name: 'properties' parameters: '()' return: '[s]').
			8 -> (QiMetaMethod uid: 8 name: 'registerEventWithSignature' parameters: '(IILs)' return: 'L').
			80 -> (QiMetaMethod uid: 80 name: 'isStatsEnabled' parameters: '()' return: 'b').
			81 -> (QiMetaMethod uid: 81 name: 'enableStats' parameters: '(b)' return: 'v').
			82 -> (QiMetaMethod uid: 82 name: 'stats' parameters: '()' return: self statsSignature).
			83 -> (QiMetaMethod uid: 83 name: 'clearStats' parameters: '()' return: 'v').
			84 -> (QiMetaMethod uid: 84 name: 'isTraceEnabled' parameters: '()' return: 'b').
			85 -> (QiMetaMethod uid: 85 name: 'enableTrace' parameters: '(b)' return: 'v').
		})
]

{ #category : #accessing }
QiMetaObject class >> metaObjectSignature [
	^ '({I(Issss[(ss)<MetaMethodParameter,name,description>]s)<MetaMethod,uid,returnSignature,name,parametersSignature,description,parameters,returnDescription>}{I(Iss)<MetaSignal,uid,name,signature>}{I(Iss)<MetaProperty,uid,name,signature>}s)<MetaObject,methods,signals,properties,description>'

]

{ #category : #accessing }
QiMetaObject class >> statsSignature [
	^ '{I(I(fff)<MinMaxSum,minValue,maxValue,cumulatedValue>(fff)<MinMaxSum,minValue,maxValue,cumulatedValue>(fff)<MinMaxSum,minValue,maxValue,cumulatedValue>)<MethodStatistics,count,wall,user,system>}'
]

{ #category : #accessing }
QiMetaObject >> description [

	^ description
]

{ #category : #accessing }
QiMetaObject >> description: anObject [

	description := anObject
]

{ #category : #accessing }
QiMetaObject >> findMethod: aString orElse: aBlock [
	"I return the QiMetaMethod i find."
	^self methods detect: [ :metaMethod |
		metaMethod name = aString
	] ifNone: aBlock
]

{ #category : #accessing }
QiMetaObject >> fromQiSlot: aQiSlot [
	description := aQiSlot description.
	properties := aQiSlot properties collect: [ :each | 
		QiMetaProperty new uid: each uid;
			name: each name;
			signature: each signature ].
	signals := aQiSlot signals collect: [ :each | 
		QiMetaSignal new uid: each uid;
			name: each name;
			signature: each signature ].
	methods := aQiSlot methods collect: [ :each | 
		QiMetaMethod uid: each uid name: each name parameters: each parametersSignature return: each returnSignature].
]

{ #category : #accessing }
QiMetaObject >> initialize [
	methods := Dictionary new.
	properties := Dictionary new.
	signals := Dictionary new.
]

{ #category : #accessing }
QiMetaObject >> methods [

	^ methods
]

{ #category : #accessing }
QiMetaObject >> methods: anObject [

	methods := anObject
]

{ #category : #accessing }
QiMetaObject >> properties [

	^ properties
]

{ #category : #accessing }
QiMetaObject >> properties: anObject [

	properties := anObject
]

{ #category : #accessing }
QiMetaObject >> signals [

	^ signals
]

{ #category : #accessing }
QiMetaObject >> signals: anObject [

	signals := anObject
]
