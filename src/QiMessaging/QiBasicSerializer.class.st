"
I am a generic serializer for basic types such as integer, strings and byte array.

I am constructed with the class methods:
	- newString
	- newInteger
	- newUnsignedInteger
	- newByteArray
	- ...

I can serialize and deserialize the concrete type from which I was created.
"
Class {
	#name : #QiBasicSerializer,
	#superclass : #QiSerializer,
	#instVars : [
		'deserializeSymbol',
		'serializeSymbol'
	],
	#category : #'QiMessaging-Core'
}

{ #category : #'instance creation' }
QiBasicSerializer class >> newBoolean [
	^ self new
		initializeWithSerializer: #serializeBoolean:into:
		withDeserializer: #deserializeBooleanFrom:
]

{ #category : #'instance creation' }
QiBasicSerializer class >> newByteArray [
	^ self new
		initializeWithSerializer: #serializeByteArray:into:
		withDeserializer: #deserializeByteArrayFrom:
]

{ #category : #'instance creation' }
QiBasicSerializer class >> newDouble [
	^ self new
		initializeWithSerializer: #serializeDouble:into:
		withDeserializer: #deserializeDoubleFrom:
]

{ #category : #'instance creation' }
QiBasicSerializer class >> newFloat [
	^ self new
		initializeWithSerializer: #serializeFloat:into:
		withDeserializer: #deserializeFloatFrom:
]

{ #category : #'instance creation' }
QiBasicSerializer class >> newInteger [
	^ self new
		initializeWithSerializer: #serializeInteger:into:
		withDeserializer: #deserializeIntegerFrom:
]

{ #category : #'instance creation' }
QiBasicSerializer class >> newString [
	^ self new
		initializeWithSerializer: #serializeString:into:
		withDeserializer: #deserializeStringFrom:
]

{ #category : #'instance creation' }
QiBasicSerializer class >> newUnsignedInteger [
	^ self new
		initializeWithSerializer: #serializeUnsignedInteger:into:
		withDeserializer: #deserializeUnsignedIntegerFrom:
]

{ #category : #serialization }
QiBasicSerializer >> deserializeBooleanFrom: aReadStream [
	aReadStream next = 0 ifTrue: [ ^false ] ifFalse: [ ^true ]
]

{ #category : #serialization }
QiBasicSerializer >> deserializeByteArrayFrom: aReadStream [
	| len array |
	len := self class readUnsignedIntegerFrom: aReadStream.
	array := ByteArray new: len.
	self class readByteArray: array from: aReadStream.
	^ array
]

{ #category : #serialization }
QiBasicSerializer >> deserializeDoubleFrom: aReadStream [
	^ self class readDoubleFrom: aReadStream
]

{ #category : #serialization }
QiBasicSerializer >> deserializeFloatFrom: aReadStream [
	^ self class readFloatFrom: aReadStream
]

{ #category : #serialization }
QiBasicSerializer >> deserializeFrom: aReadStream [
	^ self perform: deserializeSymbol with: aReadStream
]

{ #category : #serialization }
QiBasicSerializer >> deserializeIntegerFrom: aReadStream [
	^ self class readIntegerFrom: aReadStream
]

{ #category : #serialization }
QiBasicSerializer >> deserializeStringFrom: aReadStream [
	^ (self deserializeByteArrayFrom: aReadStream) asString
]

{ #category : #serialization }
QiBasicSerializer >> deserializeUnsignedIntegerFrom: aReadStream [
	^ self class readUnsignedIntegerFrom: aReadStream
]

{ #category : #serialization }
QiBasicSerializer >> initializeWithSerializer: aSymbol withDeserializer: anotherSymbol [
	serializeSymbol := aSymbol.
	deserializeSymbol := anotherSymbol.
]

{ #category : #serialization }
QiBasicSerializer >> serialize: anObject into: aWriteStream [
	^ self perform: serializeSymbol with: anObject with: aWriteStream
]

{ #category : #serialization }
QiBasicSerializer >> serializeBoolean: aBoolean into: aWriteStream [
	aWriteStream nextPut: aBoolean asBit
]

{ #category : #serialization }
QiBasicSerializer >> serializeByteArray: aByteArray into: aWriteStream [
	self class writeUnsignedInteger: aByteArray size into: aWriteStream.
	aWriteStream nextPutAll: aByteArray.
]

{ #category : #serialization }
QiBasicSerializer >> serializeDouble: aNumber into: aWriteStream [
	self class writeDouble: aNumber into: aWriteStream
]

{ #category : #serialization }
QiBasicSerializer >> serializeFloat: aNumber into: aWriteStream [
	self class writeFloat: aNumber into: aWriteStream
]

{ #category : #serialization }
QiBasicSerializer >> serializeInteger: aNumber into: aWriteStream [
	self class writeInteger: aNumber into: aWriteStream
]

{ #category : #serialization }
QiBasicSerializer >> serializeString: aString into: aWriteStream [
	self serializeByteArray: aString asByteArray into: aWriteStream.

]

{ #category : #serialization }
QiBasicSerializer >> serializeUnsignedInteger: aNumber into: aWriteStream [
	self class writeUnsignedInteger: aNumber into: aWriteStream
]
