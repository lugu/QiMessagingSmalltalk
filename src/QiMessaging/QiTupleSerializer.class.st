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

{ #category : #initialization }
QiTupleSerializer >> initialize [
	sequenceOfSerializer := Array new.
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

{ #category : #serialization }
QiTupleSerializer >> size [
	^ sequenceOfSerializer size
]
