"
I describe a QiProperty.

I have a name, an id and a signature.
"
Class {
	#name : #QiMetaProperty,
	#superclass : #Object,
	#instVars : [
		'uid',
		'name',
		'signature'
	],
	#category : #'QiMessaging-Core'
}

{ #category : #accessing }
QiMetaProperty >> initialize [
	name := ''.
	signature := ''.
	uid := 0
]

{ #category : #accessing }
QiMetaProperty >> name [

	^ name
]

{ #category : #accessing }
QiMetaProperty >> name: anObject [

	name := anObject
]

{ #category : #accessing }
QiMetaProperty >> signature [

	^ signature
]

{ #category : #accessing }
QiMetaProperty >> signature: anObject [

	signature := anObject
]

{ #category : #accessing }
QiMetaProperty >> uid [

	^ uid
]

{ #category : #accessing }
QiMetaProperty >> uid: anObject [

	uid := anObject
]
