"
I describe the method of an QiObject.

I have a name, the signature of the arguments, the signature of the returned type and an action id.

I can serialize and deserialize arguments and returned value.
"
Class {
	#name : #QiMetaMethod,
	#superclass : #Object,
	#instVars : [
		'uid',
		'returnSignature',
		'name',
		'parametersSignature',
		'description',
		'parameters',
		'returnDescription'
	],
	#category : #'QiMessaging-Core'
}

{ #category : #creation }
QiMetaMethod class >> uid: aNumber name: aStringName parameters: aStringSignature return: anotherStringSignature [
	^ self new uid: aNumber; name: aStringName;
		parametersSignature: aStringSignature; returnSignature: anotherStringSignature 
]

{ #category : #accessing }
QiMetaMethod >> createMethodFor: aClass [
	"Create the method selector representing the MetaMethod."
	"If given, the name of the arguments is generated."
	parametersSignature = '()'
		ifTrue: [
			aClass compile:
				name, String cr , '^ super callMethodId: ' , uid asString
				, ' 	withArguments: { }' ]
		ifFalse: [ 
			| aSerializer numberOfArguments |
			aSerializer := QiSignatureParser parseSignature: parametersSignature.
			"The parser should be a QiTupleParser because parameters are tuple."
			"If it is something else, it is a single parameter."
			numberOfArguments := (aSerializer isKindOf: QiTupleSerializer) ifTrue: [ aSerializer size ] ifFalse: [ 1 ]. 
			self createMethodFor: aClass withSize: numberOfArguments ]
]

{ #category : #accessing }
QiMetaMethod >> createMethodFor: aClass withSize: aNumber [
	|  source withs list params |
	params := (aNumber = parameters size) ifTrue: [
		parameters collect: [ :each | each name ].
	] ifFalse: [
		(1 to: aNumber) collect: [ :each | 'param', each asString ]
	].
	withs := ' with: ' join: params.
	list := ' . ' join: params.
	source := name , ': ', withs, String cr
		, '^ super callMethodId: ' , uid asString
		, ' 	withArguments: { ', list, ' }'.
	aClass compile: source

]

{ #category : #accessing }
QiMetaMethod >> description [

	^ description
]

{ #category : #accessing }
QiMetaMethod >> description: aString [

	description := aString
]

{ #category : #accessing }
QiMetaMethod >> deserializeResponse: anArray [
	"Deserialize the value returned by the method. Does not attempt to handle errors."
	| serializer |
	serializer := QiSignatureParser parseSignature: self returnSignature.
	^ serializer deserializeFrom: (ReadStream on: anArray).
]

{ #category : #accessing }
QiMetaMethod >> initialize [
	uid := 0.
	returnSignature := ''.
	name := ''.
	parametersSignature := ''.
	description := ''.
	parameters := Array new.
	returnDescription := ''
]

{ #category : #accessing }
QiMetaMethod >> name [

	^ name
]

{ #category : #accessing }
QiMetaMethod >> name: aString [

	name := aString
]

{ #category : #accessing }
QiMetaMethod >> parameters [

	^ parameters
]

{ #category : #accessing }
QiMetaMethod >> parameters: anArrayOfQiMetaMethodParamter [

	parameters := anArrayOfQiMetaMethodParamter
]

{ #category : #accessing }
QiMetaMethod >> parametersSignature [

	^ parametersSignature
]

{ #category : #accessing }
QiMetaMethod >> parametersSignature: aString [

	parametersSignature := aString
]

{ #category : #accessing }
QiMetaMethod >> returnDescription [

	^ returnDescription
]

{ #category : #accessing }
QiMetaMethod >> returnDescription: aString [

	returnDescription := aString
]

{ #category : #accessing }
QiMetaMethod >> returnSignature [

	^ returnSignature
]

{ #category : #accessing }
QiMetaMethod >> returnSignature: aString [

	returnSignature := aString
]

{ #category : #accessing }
QiMetaMethod >> serializeParameters: aSequence [
	"Serialize the list of argument following the argument signature of metaMethod"
	| serializer stream |
	serializer := QiSignatureParser parseSignature: self parametersSignature.
	stream := WriteStream on: ByteArray new.
	serializer serialize: aSequence into: stream.
	^ stream contents
]

{ #category : #accessing }
QiMetaMethod >> uid [

	^ uid
]

{ #category : #accessing }
QiMetaMethod >> uid: aNumber [

	uid := aNumber
]
