"
I am a generic interface able to serialize and deserialize a value.

Instances of my class are usually built by the QiSignatureParser.

I have two methods:
	- serialize: aWriteStream value: aQiValue
	- deserialize: aReadStream value: aQiValue
"
Class {
	#name : #QiSerializer,
	#superclass : #Object,
	#category : #'QiMessaging-Core'
}

{ #category : #internal }
QiSerializer class >> readByteArray: aByteArray from: aReadStream [
	aReadStream readInto: aByteArray startingAt: 1 count: aByteArray size.
]

{ #category : #internal }
QiSerializer class >> readDoubleFrom: aReadStream [
	| buffer |
	buffer := ByteArray new: 8.
	aReadStream readInto: buffer startingAt: 1 count: 8.
	^ buffer doubleAt: 1 bigEndian: false.
]

{ #category : #internal }
QiSerializer class >> readFloatFrom: aReadStream [
	| buffer |
	buffer := ByteArray new: 4.
	aReadStream readInto: buffer startingAt: 1 count: 4.
	^ buffer floatAt: 1 bigEndian: false.
]

{ #category : #internal }
QiSerializer class >> readIntegerFrom: aReadStream [
	| buffer |
	buffer := ByteArray new: 4.
	aReadStream readInto: buffer startingAt: 1 count: 4.
	^ buffer longAt: 1 bigEndian: false.
]

{ #category : #internal }
QiSerializer class >> readUnsignedIntegerFrom: aReadStream [
	| buffer |
	buffer := ByteArray new: 4.
	aReadStream readInto: buffer startingAt: 1 count: 4.
	^ buffer unsignedLongAt: 1 bigEndian: false.
]

{ #category : #internal }
QiSerializer class >> writeByteArray: aByteArray into: aWriteStream [
	aWriteStream nextPutAll: aByteArray.
]

{ #category : #internal }
QiSerializer class >> writeDouble: anInteger into: aWriteStream [
	| data |
	data := ByteArray new: 8.
	data doubleAt: 1 put: anInteger.
	aWriteStream nextPutAll: data.
	
]

{ #category : #internal }
QiSerializer class >> writeFloat: anInteger into: aWriteStream [
	| data |
	data := ByteArray new: 4.
	data floatAt: 1 put: anInteger.
	aWriteStream nextPutAll: data.
	
]

{ #category : #internal }
QiSerializer class >> writeInteger: anInteger into: aWriteStream [
	| data |
	data := ByteArray new: 4.
	data longAt: 1 put: anInteger bigEndian: false.
	aWriteStream nextPutAll: data.
	
]

{ #category : #internal }
QiSerializer class >> writeUnsignedInteger: anInteger into: aWriteStream [
	| data |
	data := ByteArray new: 4.
	data unsignedLongAt: 1 put: anInteger bigEndian: false.
	aWriteStream nextPutAll: data.
	
]

{ #category : #serialization }
QiSerializer >> deserializeFrom: aWriteStream [
	^ SubclassResponsibility new signal
]

{ #category : #serialization }
QiSerializer >> serialize: anObject into: aWriteStream [
	^ SubclassResponsibility new signal
]
