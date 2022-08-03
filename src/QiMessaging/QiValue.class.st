"
I represent a type value which can represent any value used to send and read data.

I am composed of a signature which describes my type and a value hold the data.

Basic types

    'i': signed integer: 32 bits signed.
    'I': unsigned integer: 32 bits signed.
    'f': float: 32 bits (IEEE 754)
    'd': double: 64 bits (IEEE 754)
    'l': long: 64 bits signed value
    'L': unsigned long: 64 bits signed value
    'b': bool: boolean value
    's': string: string of character
    'r': raw data: array of bytes
    'X': unknown: no information

When describing the return type of a method:

    'v': void: the method is not returning a result other than the information of its successful completion.

Value

    'm': value: a container type. It can contains any type.

Composite types

    '[' ... ']': array: a sequence of elements of the same type.
    '{' ... ... '}': dictionary: associative array from a key type to an element type.
    '(' ... ')<' ... .... '>': structure: a limited set of name element of different types.

Object

    'o': a reference to a QiObject. 

Other

    'X': an unknown type.
"
Class {
	#name : #QiValue,
	#superclass : #Object,
	#instVars : [
		'value',
		'signature',
		'serializer'
	],
	#category : #'QiMessaging-Core'
}

{ #category : #'instance creation' }
QiValue class >> newString: aString [
	^ self new value: aString signature: 's'
]

{ #category : #accessing }
QiValue >> asError [
	^ QiError new value: value signature: signature serializer: serializer.
]

{ #category : #accessing }
QiValue >> deserializeContent: aReadStream [
	value := serializer deserializeFrom: aReadStream. 
]

{ #category : #accessing }
QiValue >> serializeContent: aWriteStream [
	serializer serialize: value into: aWriteStream.
]

{ #category : #accessing }
QiValue >> serializer [
	^ serializer
]

{ #category : #accessing }
QiValue >> signature [
	^ signature
]

{ #category : #evaluating }
QiValue >> value [
	^ value
]

{ #category : #accessing }
QiValue >> value: anObject signature: aString [
	value := anObject.
	signature := aString.
	serializer := QiSignatureParser parseSignature: signature.
]

{ #category : #accessing }
QiValue >> value: anObject signature: aString serializer: aQiSerializer [
	value := anObject.
	signature := aString.
	serializer := aQiSerializer.
]
