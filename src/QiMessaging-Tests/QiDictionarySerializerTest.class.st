Class {
	#name : #QiDictionarySerializerTest,
	#superclass : #QiSerializerTest,
	#category : #'QiMessaging-Tests'
}

{ #category : #tests }
QiDictionarySerializerTest >> testDictOfStringAndInteger [
	| serializer |
	serializer := QiDictionarySerializer new
		keySerializer: QiBasicSerializer newString 
		valueSerializer: QiBasicSerializer newInteger.
	{ 
		Dictionary new. 
		Dictionary newFrom: { 'a' -> 333 }.
		Dictionary newFrom: { 'a' -> 1. 'b' -> 2. 'c' -> 3 }.
	}  do: [ :aDictionary |
		| buffer anotherDictionary |
		buffer := ReadWriteStream on: ByteArray new.
		serializer serialize: aDictionary into: buffer.
		buffer reset.
		anotherDictionary := serializer deserializeFrom: buffer.
		self assert: aDictionary equals: anotherDictionary
	]
		
]
