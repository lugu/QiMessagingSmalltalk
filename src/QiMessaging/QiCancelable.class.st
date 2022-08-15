"
I represents an action which can be cancelled.

I am used to stop the registration of a signal.

I have two methods:
	* onCancel:
	* cancel

Calling the call-back is exectuted at most once even if cancel is called more than once.
"
Class {
	#name : #QiCancelable,
	#superclass : #Object,
	#instVars : [
		'block'
	],
	#category : #'QiMessaging-Core'
}

{ #category : #actions }
QiCancelable >> cancel [
	"Exectute the block set with onCancel."
	"The cancel action is only executed once."	
	| oldBlock |
	oldBlock := block.
	block := [ ].
	^ oldBlock value.
]

{ #category : #actions }
QiCancelable >> initialize [
	block := [ ]
]

{ #category : #actions }
QiCancelable >> onCancel: aBlock [
	"Set the call-back to execute when the cancel message is recieved"
	block := aBlock.
]
