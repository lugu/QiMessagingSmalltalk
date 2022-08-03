"
I can serialize and deserialize a Dictionary.

The keys should all be of the same type.
The values should all be of the same type.
"
Class {
	#name : #QiDictionarySerializer,
	#superclass : #QiSerializer,
	#instVars : [
		'keySerializer',
		'valueSerializer'
	],
	#category : #'QiMessaging-Core'
}

{ #category : #serialization }
QiDictionarySerializer >> deserializeFrom: aReadStream [
	| len dict |
	len := self class readUnsignedIntegerFrom: aReadStream.
	dict := Dictionary new.
	len timesRepeat: [ 
		| key value|
		key := keySerializer deserializeFrom: aReadStream.
		value := valueSerializer deserializeFrom: aReadStream.
		dict at: key put: value ].
	^dict
]

{ #category : #initialization }
QiDictionarySerializer >> keySerializer: aSerializer valueSerializer: anotherSerializer [
	keySerializer := aSerializer.
	valueSerializer := anotherSerializer
]

{ #category : #serialization }
QiDictionarySerializer >> serialize: aDictionary into: aWriteStream [
	self class writeUnsignedInteger: aDictionary size into: aWriteStream.
	aDictionary keysAndValuesDo: [ :key :value | 
		keySerializer serialize: key into: aWriteStream.
		valueSerializer serialize: value into: aWriteStream
	]

]
