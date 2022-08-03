Class {
	#name : #QiSructSerializerTest,
	#superclass : #QiSerializerTest,
	#category : #'QiMessaging-Tests'
}

{ #category : #tests }
QiSructSerializerTest >> inputData [
	^ OrderedDictionary newFrom: { 
			#param1 -> {66. QiBasicSerializer newInteger}.
			#param2 -> {'Hello Wolrd'. QiBasicSerializer newString}.
			#param3 -> {true. QiBasicSerializer newBoolean}.
	}
]

{ #category : #tests }
QiSructSerializerTest >> inputObject [
	| class anObject |
	class := Object newAnonymousSubclass.
	self inputValues keysDo: [ :symbol | 
		class := class addSlot: symbol => InstanceVariableSlot ].
	anObject := class new.

	self inputValues keysAndValuesDo: [ :symbol :value | 
		| slot |
		slot := anObject class slotNamed: symbol.
		slot write: value to: anObject.
		self assert: (slot read: anObject) equals: value ].
	^anObject
]

{ #category : #tests }
QiSructSerializerTest >> inputSerializer [
	^ self inputData collect: [:value | value second ].
]

{ #category : #tests }
QiSructSerializerTest >> inputValues [
	^ self inputData collect: [:value | value first ].
]

{ #category : #tests }
QiSructSerializerTest >> outputObject [

	| serializer buffer |
	serializer := QiStructSerializer new
		              serializerDictionary: self inputSerializer
		              withStructName: 'Test'.
		
	buffer := ReadWriteStream on: ByteArray new.
	serializer serialize: self inputObject into: buffer.
	buffer reset.
	^ serializer deserializeFrom: buffer.

]

{ #category : #tests }
QiSructSerializerTest >> testSructAccessors [
	| anotherObject |
	anotherObject := self outputObject.
	self inputValues keysAndValuesDo: [ :symbol :value | 
		self assert: (anotherObject perform: symbol) equals: value.
		anotherObject perform: (symbol, ':') with: value.
	].
]

{ #category : #tests }
QiSructSerializerTest >> testSructSerialization [
	| serializer anObject anotherObject slots |
	serializer := QiStructSerializer new
		              serializerDictionary: self inputSerializer
		              withStructName: 'Test'.
		
	slots := self inputValues.
	anObject := self inputObject.
	anotherObject := self outputObject.

	slots keysAndValuesDo: [ :symbol :value | 
		| slot |
		slot := anObject class slotNamed: symbol.
		self assert: (slot read: anotherObject) equals: value ].

]

{ #category : #tests }
QiSructSerializerTest >> testStructNameAndArgs [

	| anotherObject slots |
		
	slots := self inputValues.
	anotherObject := self outputObject.

	self assert: anotherObject structName equals: 'Test'.
	anotherObject args
		with: slots values
		do: [ :received :expected | self assert: received equals: expected ].
]
