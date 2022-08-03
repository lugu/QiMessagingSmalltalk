Class {
	#name : #QiMetaObjectTest,
	#superclass : #QiTestCase,
	#category : #'QiMessaging-Tests'
}

{ #category : #tests }
QiMetaObjectTest >> testParseMetaObjectSignature [
	| serializer |
	serializer := QiSignatureParser new parse: QiMetaObject metaObjectSignature.
	self assert: (serializer isKindOf: QiSerializer)
]

{ #category : #tests }
QiMetaObjectTest >> testParseStatsSignature [
	| serializer |
	serializer := QiSignatureParser new parse: QiMetaObject statsSignature.
	self assert: (serializer isKindOf: QiSerializer)
]
