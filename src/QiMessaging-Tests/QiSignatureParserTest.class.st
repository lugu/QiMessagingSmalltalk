Class {
	#name : #QiSignatureParserTest,
	#superclass : #QiTestCase,
	#category : #'QiMessaging-Tests'
}

{ #category : #tests }
QiSignatureParserTest >> testParseArraySignatures [
	#( 	'[i]' '[I]' '[[s]]' '[r]') do: [ :validSignature |
			| serializer |
			serializer := QiSignatureParser new parse: validSignature.
			self assert: (serializer isKindOf: QiArraySerializer). 
	 ].
]

{ #category : #tests }
QiSignatureParserTest >> testParseBasicSignatures [
	#( 	'i' 'I' 's' 'r' 'b' 'f' 'd') do: [ :validSignature |
			| serializer |
			serializer := QiSignatureParser new parse: validSignature.
			self assert: (serializer isKindOf: QiSerializer). 
	 ].
	#( 	'a' 'h' 'q' '@') do: [ :validSignature |
			| serializer |
			serializer := QiSignatureParser new parse: validSignature.
			self assert: (serializer isKindOf: PPFailure). 
	 ]
]

{ #category : #tests }
QiSignatureParserTest >> testParseCompositeSignatures [
	#(
		'{i[i]}'
		'[{sr}]'
		'{[{Ir}]{is}}'
		'([i]{(ss)b})'
		'([i]{(ss)<name,a,b>b})<other,c,d>'
		'(Issss[(ss)<MetaMethodParameter,name,description>]s)<MetaMethod,uid,returnSignature,name,parametersSignature,description,parameters,returnDescription>'
	) do: [ :validSignature |
			| serializer |
			serializer := QiSignatureParser parseSignature: validSignature.
			self assert: (serializer isKindOf: QiSerializer). 
	 ]
]

{ #category : #tests }
QiSignatureParserTest >> testParseDictionarySignatures [
	#( 	'{ii}' '{sr}' '{rI}' '{{si}r}') do: [ :validSignature |
			| serializer |
			serializer := QiSignatureParser new parse: validSignature.
			self assert: (serializer isKindOf: QiDictionarySerializer). 
	 ].
]

{ #category : #tests }
QiSignatureParserTest >> testParseSructSignatures [
	#(
		'()<aName>'
		'(I)<tower,size>'
		'(sb)<button,label,isActive>'
		'(si(b(r)<file,bytes>r)<foo,one,two,three>I)<bar,un,deux,trois,quatres>'
	) do: [ :validSignature |
			| serializer |
			serializer := QiSignatureParser new parse: validSignature.
			self assert: (serializer isKindOf: QiStructSerializer). 
	 ].
]

{ #category : #tests }
QiSignatureParserTest >> testParseTupleSignatures [
	#( 	'()' '(I)' '(sb)' '(si(b(r)r)I)' '(IIL)') do: [ :validSignature |
			| serializer |
			serializer := QiSignatureParser new parse: validSignature.
			self assert: (serializer isKindOf: QiTupleSerializer). 
	 ].
]

{ #category : #tests }
QiSignatureParserTest >> testParseValueSignature [
	| serializer |
	serializer := QiSignatureParser new parse: 'm'.
	self assert: (serializer isKindOf: QiValueSerializer)
]

{ #category : #tests }
QiSignatureParserTest >> testParseVoidSignature [
	| serializer |
	serializer := QiSignatureParser new parse: 'v'.
	self assert: (serializer isKindOf: QiSerializer)
]
