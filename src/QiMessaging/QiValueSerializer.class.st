"
I serialize QiValue.
"
Class {
	#name : #QiValueSerializer,
	#superclass : #QiSerializer,
	#category : #'QiMessaging-Core'
}

{ #category : #serialization }
QiValueSerializer >> deserializeFrom: aReadStream [
	| signature serializer value |
	signature := QiBasicSerializer newString deserializeFrom: aReadStream.
	serializer := QiSignatureParser parseSignature: signature.	
	value := serializer deserializeFrom: aReadStream.
	^ QiValue new value: value signature: signature serializer: serializer 
]

{ #category : #serialization }
QiValueSerializer >> serialize: aQiValue into: aWriteStream [
	QiBasicSerializer newString serialize: aQiValue signature into: aWriteStream.
	aQiValue serializer serialize: aQiValue value into: aWriteStream.
]
