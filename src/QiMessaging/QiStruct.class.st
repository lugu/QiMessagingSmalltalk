"
I am a container for slots.

You can inherited me and add your slots. I will make them available via the args method.
Don't forget to name the subclass by overloading the name method.
"
Class {
	#name : #QiStruct,
	#superclass : #Object,
	#category : #'QiMessaging-Core'
}

{ #category : #accessing }
QiStruct >> args [
	"Returns an array with the instance variables."
	^ self class instanceVariables collect: [ :slot | slot read: self ]

]

{ #category : #accessing }
QiStruct >> name [
	^ SubclassResponsibility new signal
]
