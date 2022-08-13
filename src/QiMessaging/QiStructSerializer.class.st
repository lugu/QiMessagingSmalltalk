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
		'classSymbol'
	],
	#category : #'QiMessaging-Core'
}

{ #category : #serialization }
QiStructSerializer >> createQiStructClass [

	| class instVarNameList |
	instVarNameList := ' ' join: orderedDictionaryOfSerializer keys.
	class := QiStruct
		         subclass: classSymbol
		         instanceVariableNames: instVarNameList
		         classVariableNames: #(  )
		         package: 'QiMessaging-Generated' asSymbol.
	orderedDictionaryOfSerializer keysDo: [ :each | 
		class compile: each , String cr , '^' , each.
		class compile: each , ': value' , String cr , each , ':= value' ].
	^ class
]

{ #category : #serialization }
QiStructSerializer >> deserializeFrom: aReadStream [
	| class object |
	class :=  Smalltalk at: classSymbol ifAbsent: [ self createQiStructClass ].
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
	classSymbol := ('Qim', aString) asSymbol.
]
