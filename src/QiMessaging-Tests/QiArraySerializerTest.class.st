Class {
	#name : #QiArraySerializerTest,
	#superclass : #QiSerializerTest,
	#category : #'QiMessaging-Tests'
}

{ #category : #tests }
QiArraySerializerTest >> testArrayOfInteger [
	| serializer |
	serializer := QiArraySerializer new elementSerializer: QiBasicSerializer newInteger.
	#(
		#()
		#(999)
		#(1 2 3 4 5)
	)  do: [ :anArray |
		| buffer anotherArray |
		buffer := ReadWriteStream on: ByteArray new.
		serializer serialize: anArray into: buffer.
		buffer reset.
		anotherArray := serializer deserializeFrom: buffer.
		self assert: anArray equals: anotherArray
	]
		
]

{ #category : #tests }
QiArraySerializerTest >> testArrayOfString [
	| serializer |
	serializer := QiArraySerializer new elementSerializer: QiBasicSerializer newInteger.
	#(
		#()
		#(999)
		#(1 2 3 4 5)
	)  do: [ :anArray |
		| buffer anotherArray |
		buffer := ReadWriteStream on: ByteArray new.
		serializer serialize: anArray into: buffer.
		buffer reset.
		anotherArray := serializer deserializeFrom: buffer.
		self assert: anArray equals: anotherArray
	]
		
]
