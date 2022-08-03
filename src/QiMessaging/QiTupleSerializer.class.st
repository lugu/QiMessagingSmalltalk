"
I am able to serialize a tuple.
"
Class {
	#name : #QiTupleSerializer,
	#superclass : #QiSerializer,
	#instVars : [
		'sequenceOfSerializer'
	],
	#category : #'QiMessaging-Core'
}

{ #category : #serialization }
QiTupleSerializer >> deserializeFrom: aReadStream [
	^ sequenceOfSerializer collect: [ :serializer |
		serializer deserializeFrom: aReadStream ]
]

{ #category : #serialization }
QiTupleSerializer >> initialize [
	sequenceOfSerializer := SequenceableCollection new.
]

{ #category : #serialization }
QiTupleSerializer >> serialize: aSequenceableCollection into: aWriteStream [
	sequenceOfSerializer with: aSequenceableCollection do: [ :serializer :value |
		serializer serialize: value into: aWriteStream ]
]

{ #category : #serialization }
QiTupleSerializer >> serializers: aSequenceableCollection [
	sequenceOfSerializer := aSequenceableCollection
]
