"
I represent an error. I am QiValue with a string.
"
Class {
	#name : #QiError,
	#superclass : #QiValue,
	#category : #'QiMessaging-Core'
}

{ #category : #'instance creation' }
QiError class >> new: aString [
	^ self new value: aString signature: 's'
]
