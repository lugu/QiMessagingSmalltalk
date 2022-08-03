"
I can serialize and deserialize the slots (instance variables) of an object.

In the context of QiMessage, we use slots to represent (in Smalltalk) the list of parameters sent when invoking an Action.

This concept is referred as ""struct"" in other programming language.
"
Class {
	#name : #QiStructSerializer,
	#superclass : #QiSerializer,
	#instVars : [
		'orderedDictionaryOfSerializer',
		'name'
	],
	#category : #'QiMessaging-Core'
}

{ #category : #serialization }
QiStructSerializer >> createQiStructClass [
	| class |
	class := QiSlots newAnonymousSubclass.
	class compile: 'structName', String cr, '^', name surroundedBySingleQuotes.
	^ class
]

{ #category : #serialization }
QiStructSerializer >> createQiStructClassWithSymbols: anArray [
	| class |
	class := self createQiStructClass.
	anArray do: [ :symbol |
		class := class addSlot: symbol => InstanceVariableSlot.
		class compile: symbol asString, String cr, '^', symbol asString.
		class compile: symbol asString, ': value', String cr, symbol asString, ':= value'.
	 ].	
	^ class
]

{ #category : #serialization }
QiStructSerializer >> deserializeFrom: aReadStream [
	| class object |
	class := self createQiStructClassWithSymbols: orderedDictionaryOfSerializer keys.
	object := class new.	
	orderedDictionaryOfSerializer keysAndValuesDo: [ :aSymbol :serializer |
		| value |
		value := serializer deserializeFrom: aReadStream.
		(class slotNamed: aSymbol) write: value to: object
	].
	^object
]

{ #category : #serialization }
QiStructSerializer >> serialize: anObject into: aWriteStream [
	orderedDictionaryOfSerializer keysAndValuesDo: [ :aSymbol :serializer |
		| slot |
		slot := anObject class slotNamed: aSymbol.
		serializer serialize: (slot read: anObject) into: aWriteStream
	]

]

{ #category : #serialization }
QiStructSerializer >> serializerDictionary: anOrderedDictionaryOfSerializer withStructName: aString [
	orderedDictionaryOfSerializer := anOrderedDictionaryOfSerializer.
	name := aString
]
