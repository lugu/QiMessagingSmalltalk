"
I am able to serialize an Array of element of the same type.

The binary format of the array is an integer representing the length followed by the serialization of the elements.
"
Class {
	#name : #QiArraySerializer,
	#superclass : #QiSerializer,
	#instVars : [
		'elementSerializer'
	],
	#category : #'QiMessaging-Core'
}

{ #category : #serialization }
QiArraySerializer >> deserializeFrom: aReadStream [
	| len |
	len := self class readUnsignedIntegerFrom: aReadStream.
	^ (Array new: len) collect: [ :i |  elementSerializer deserializeFrom: aReadStream ].
]

{ #category : #serialization }
QiArraySerializer >> elementSerializer: aSerializer [
	elementSerializer := aSerializer
]

{ #category : #serialization }
QiArraySerializer >> serialize: anArray into: aWriteStream [
	self class writeUnsignedInteger: anArray size into: aWriteStream.
	anArray do: [:v | elementSerializer serialize: v into: aWriteStream ]
]
