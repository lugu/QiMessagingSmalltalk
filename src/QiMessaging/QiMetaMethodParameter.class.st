"
I describre the arguments of a method.

For each argument, I hold a description.

I am optional in a QiMetaMethod.
"
Class {
	#name : #QiMetaMethodParameter,
	#superclass : #Object,
	#instVars : [
		'name',
		'description'
	],
	#category : #'QiMessaging-Core'
}

{ #category : #accessing }
QiMetaMethodParameter >> description [

	^ description
]

{ #category : #accessing }
QiMetaMethodParameter >> description: aString [

	description := aString
]

{ #category : #initialization }
QiMetaMethodParameter >> initialize [
	name := ''.
	description := ''
]

{ #category : #accessing }
QiMetaMethodParameter >> name [

	^ name
]

{ #category : #accessing }
QiMetaMethodParameter >> name: aString [

	name := aString
]
