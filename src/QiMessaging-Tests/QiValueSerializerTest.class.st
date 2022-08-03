Class {
	#name : #QiValueSerializerTest,
	#superclass : #QiSerializerTest,
	#category : #'QiMessaging-Tests'
}

{ #category : #tests }
QiValueSerializerTest >> testValues [
	| serializer input |
	serializer := QiValueSerializer new.
	input := Dictionary newFrom: { 
		'i' -> 66.
		's' -> 'Hello World'.
		'b' -> true.
		'r' -> #(1 2 3) asByteArray.
		'[i]' -> #(1 2 3).
	}.
	input keysAndValuesDo: [ :signature :data |
		| valueIn valueOut buffer |
		valueIn := QiValue new value: data signature: signature.
		buffer := ReadWriteStream on: ByteArray new.
		serializer serialize: valueIn into: buffer.
		buffer reset.
		valueOut := serializer deserializeFrom: buffer.
		self assert: (valueOut isKindOf: QiValue).
		self assert: valueOut signature equals: signature.
		self assert: valueOut value equals: data.
	]
]
