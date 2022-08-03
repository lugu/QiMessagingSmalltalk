Class {
	#name : #QiSerializerTest,
	#superclass : #QiTestCase,
	#category : #'QiMessaging-Tests'
}

{ #category : #tests }
QiSerializerTest >> testSubclassResponsibilityError [
	self should: [QiSerializer new serialize: nil into: nil ] raise: SubclassResponsibility.
	self should: [QiSerializer new deserializeFrom: nil ] raise: SubclassResponsibility.
	
]
