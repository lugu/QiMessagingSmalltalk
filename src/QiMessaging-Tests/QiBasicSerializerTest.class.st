Class {
	#name : #QiBasicSerializerTest,
	#superclass : #QiSerializerTest,
	#category : #'QiMessaging-Tests'
}

{ #category : #tests }
QiBasicSerializerTest >> testBoolean [
	| serializer |
	serializer := QiBasicSerializer newBoolean.
	#(true false) do: [ :aBool |
		| buffer anotherBool |
		buffer := ReadWriteStream on: ByteArray new.
		serializer serialize: aBool into: buffer.
		buffer reset.
		anotherBool := serializer deserializeFrom: buffer.
		self assert: anotherBool equals: aBool
	]
		
]

{ #category : #tests }
QiBasicSerializerTest >> testByteArray [
	| serializer |
	serializer := QiBasicSerializer newByteArray.
	#('' 'a' 'abc' 'Hello, World!') do: [ :aString |
		| buffer aByteArray |
		buffer := ReadWriteStream on: ByteArray new.
		serializer serialize: aString asByteArray into: buffer.
		buffer reset.
		aByteArray := serializer deserializeFrom: buffer.
		self assert: aByteArray equals: aString asByteArray
	]
		
]

{ #category : #tests }
QiBasicSerializerTest >> testDouble [
	| serializer |
	serializer := QiBasicSerializer newDouble.
	#(6.2 0.0 1 6.1 3 -2 99 ) do: [ :aNumber |
		| buffer anotherNumber |
		buffer := ReadWriteStream on: ByteArray new.
		serializer serialize: aNumber into: buffer.
		buffer reset.
		anotherNumber := serializer deserializeFrom: buffer.
		self assert: ((anotherNumber - aNumber) < 0.01)
	]
		
]

{ #category : #tests }
QiBasicSerializerTest >> testFloat [
	| serializer |
	serializer := QiBasicSerializer newFloat.
	#(6.2 0.0 1 6.1 3 -2 99 ) do: [ :aNumber |
		| buffer anotherNumber |
		buffer := ReadWriteStream on: ByteArray new.
		serializer serialize: aNumber into: buffer.
		buffer reset.
		anotherNumber := serializer deserializeFrom: buffer.
		self assert: ((anotherNumber - aNumber) < 0.01)
	]
		
]

{ #category : #tests }
QiBasicSerializerTest >> testInteger [
	| serializer |
	serializer := QiBasicSerializer newInteger.
	#(6 0 1 2 3 -2 99 ) do: [ :aNumber |
		| buffer anotherNumber |
		buffer := ReadWriteStream on: ByteArray new.
		serializer serialize: aNumber into: buffer.
		buffer reset.
		anotherNumber := serializer deserializeFrom: buffer.
		self assert: anotherNumber equals: aNumber
	]
		
]

{ #category : #tests }
QiBasicSerializerTest >> testString [
	| serializer |
	serializer := QiBasicSerializer newString.
	#('' 'a' 'abc' 'Hello, World!') do: [ :aString |
		| buffer anotherString |
		buffer := ReadWriteStream on: ByteArray new.
		serializer serialize: aString into: buffer.
		buffer reset.
		anotherString := serializer deserializeFrom: buffer.
		self assert: anotherString equals: aString
	]
		
]

{ #category : #tests }
QiBasicSerializerTest >> testUnsignedInteger [
	| serializer |
	serializer := QiBasicSerializer newUnsignedInteger.
	#(6 0 1 2 3 99 ) do: [ :aNumber |
		| buffer anotherNumber |
		buffer := ReadWriteStream on: ByteArray new.
		serializer serialize: aNumber into: buffer.
		buffer reset.
		anotherNumber := serializer deserializeFrom: buffer.
		self assert: anotherNumber equals: aNumber
	]
		
]
