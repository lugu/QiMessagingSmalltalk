"
I am a signature parser.

I take a signature as input and produce a QiSerializer.

I am used to serialize and deserialize QiValue.
"
Class {
	#name : #QiSignatureParser,
	#superclass : #PPCompositeParser,
	#instVars : [
		'bytearray',
		'boolean',
		'integer',
		'unsignedInteger',
		'longLong',
		'unsignedLongLong',
		'signature',
		'string',
		'array',
		'tuple',
		'dictionary',
		'symbol',
		'names',
		'struct',
		'void',
		'value',
		'float',
		'double'
	],
	#classInstVars : [
		'aQiSignatureParser',
		'cacheDictionary'
	],
	#category : #'QiMessaging-Core'
}

{ #category : #parsing }
QiSignatureParser class >> flushCache [
	aQiSignatureParser := self new.
	cacheDictionary := Dictionary new
]

{ #category : #parsing }
QiSignatureParser class >> parseSignature: aString [

	"Return the serializer of the signature."
	^ self new parse: aString.
	
	"If not found in the cache, create the seralizer"
	"
	aQiSignatureParser ifNil: [	aQiSignatureParser := self new ].
	cacheDictionary ifNil: [ cacheDictionary := Dictionary new ].
	^ cacheDictionary at: aString ifAbsentPut: [ aQiSignatureParser parse: aString].
	"
]

{ #category : #parsers }
QiSignatureParser >> array [
	^ ('[' asParser, signature, ']' asParser) ==> [ :nodes |
		QiArraySerializer new elementSerializer: nodes second ]
]

{ #category : #parsers }
QiSignatureParser >> boolean [
	^ 'b' asParser token ==> [ :aToken | QiBasicSerializer newBoolean ]
]

{ #category : #parsers }
QiSignatureParser >> bytearray [
	^ 'r' asParser token ==> [ :aToken | QiBasicSerializer newByteArray ]
]

{ #category : #parsers }
QiSignatureParser >> dictionary [
	^ ('{' asParser, signature, signature, '}' asParser) ==> [ :nodes |
		| key value |
		key := nodes at: 2.
		value := nodes at: 3.
		QiDictionarySerializer new keySerializer: key valueSerializer: value ]
]

{ #category : #parsers }
QiSignatureParser >> double [
	^ 'd' asParser token ==> [ :aToken | QiBasicSerializer newDouble ]
]

{ #category : #parsers }
QiSignatureParser >> float [
	^ 'f' asParser token ==> [ :aToken | QiBasicSerializer newFloat ]
]

{ #category : #parsers }
QiSignatureParser >> integer [
	^ 'i' asParser token ==> [ :aToken | QiBasicSerializer newInteger ]
]

{ #category : #parsers }
QiSignatureParser >> longLong [
	^ 'l' asParser token ==> [ :aToken | QiBasicSerializer newLongLong ]
]

{ #category : #parsers }
QiSignatureParser >> names [
	^ (symbol separatedBy: ',' asParser) withoutSeparators / symbol star
]

{ #category : #parsers }
QiSignatureParser >> signature [
	^ void /
		integer /
		unsignedInteger /
		float /
		double /
		boolean /
		longLong /
		unsignedLongLong /
		string /
		bytearray /
		array /
		value /
		dictionary /
		struct /
		tuple
]

{ #category : #accessing }
QiSignatureParser >> start [
	^ signature end
]

{ #category : #parsers }
QiSignatureParser >> string [
	^ 's' asParser token ==> [ :aToken | QiBasicSerializer newString ]
]

{ #category : #parsers }
QiSignatureParser >> struct [
	^ ('(' asParser, signature star, ')' asParser, '<' asParser, names, '>' asParser) ==> [ :nodes |
		| parsers symbols structName serializerDictionary |
		parsers := nodes at: 2.
		symbols := nodes at: 5.
		structName := symbols first.
		serializerDictionary := OrderedDictionary new.
		symbols allButFirst with: parsers do: [ :aSymbol :aParser |
			serializerDictionary at: aSymbol put: aParser.
		].
		QiStructSerializer new serializerDictionary: serializerDictionary withStructName: structName]
]

{ #category : #parsers }
QiSignatureParser >> symbol [
	^ (#letter asParser, (( #word asParser / $_ asParser) star)) flatten token ==> [ :node | node inputValue asSymbol]
	"^ #word asParser plus token ==> [ :node | node inputValue asSymbol]"
]

{ #category : #parsers }
QiSignatureParser >> tuple [
	^ ('(' asParser, signature star, ')' asParser) ==> [ :nodes |
		QiTupleSerializer new serializers: nodes second ]
]

{ #category : #parsers }
QiSignatureParser >> unsignedInteger [
	^ 'I' asParser token ==> [ :aToken | QiBasicSerializer newUnsignedInteger ]
]

{ #category : #parsers }
QiSignatureParser >> unsignedLongLong [
	^ 'L' asParser token ==> [ :aToken | QiBasicSerializer newUnsignedLongLong ]
]

{ #category : #parsers }
QiSignatureParser >> value [
	^ 'm' asParser token ==> [ :aToken | QiValueSerializer new ]
]

{ #category : #parsers }
QiSignatureParser >> void [
	^ 'v' asParser token ==> [ :aToken | QiTupleSerializer new ]
]
