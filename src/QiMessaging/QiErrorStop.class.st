"
I represent a normal terminaison.

I am sent to receiver when it is removed from the QiChannel.
"
Class {
	#name : #QiErrorStop,
	#superclass : #QiError,
	#category : #'QiMessaging-Core'
}

{ #category : #'class initialization' }
QiErrorStop class >> initialize [
	self value: 'QiErrorStop: normal interruption' signature: 's'
]

{ #category : #initialization }
QiErrorStop >> initialize [ 
	self value: 'QiErrorStop: normal interruption' signature: 's'
]
