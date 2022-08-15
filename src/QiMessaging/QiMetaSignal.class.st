"
I describe a QiSignal.

I have a name, an id and a signature.
"
Class {
	#name : #QiMetaSignal,
	#superclass : #Object,
	#instVars : [
		'uid',
		'name',
		'signature'
	],
	#category : #'QiMessaging-Core'
}

{ #category : #initialization }
QiMetaSignal >> createSignalFor: aClass [
	aClass compile: 'on', name capitalized, 'Do: aBlockWithOneArgument', String cr,
		'"Invoke the block with the new value each time the signal is raise"', String cr,
		'"Return a QiReceiver shall be used to unregister to the signal."', String cr,
		'^ self registerToSignal: ', name surroundedBySingleQuotes, ' with: aBlockWithOneArgument'.
]

{ #category : #initialization }
QiMetaSignal >> initialize [
	name := ''.
	signature := ''.
	uid := 0
]

{ #category : #accessing }
QiMetaSignal >> name [

	^ name
]

{ #category : #accessing }
QiMetaSignal >> name: anObject [

	name := anObject
]

{ #category : #accessing }
QiMetaSignal >> signature [

	^ signature
]

{ #category : #accessing }
QiMetaSignal >> signature: anObject [

	signature := anObject
]

{ #category : #accessing }
QiMetaSignal >> uid [

	^ uid
]

{ #category : #accessing }
QiMetaSignal >> uid: anObject [

	uid := anObject
]
