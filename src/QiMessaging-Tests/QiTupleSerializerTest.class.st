Class {
	#name : #QiTupleSerializerTest,
	#superclass : #QiSerializerTest,
	#category : #'QiMessaging-Tests'
}

{ #category : #tests }
QiTupleSerializerTest >> testTuple [
	| serializer tuple buffer anotherTuple |
	serializer := QiTupleSerializer new serializers: {
		QiBasicSerializer newInteger.
		QiBasicSerializer newString.
		QiBasicSerializer newBoolean.
	}.
	tuple := 	#(99 'hello' true).
	buffer := ReadWriteStream on: ByteArray new.
	serializer serialize: tuple into: buffer.
	buffer reset.
	anotherTuple := serializer deserializeFrom: buffer.
	self assert: tuple equals: anotherTuple
]
