"
I am the header of a QiMessage, describing the payload and the destination.

I contain the size of the payload and the destination of the message (service, object, action).	

My binary representation is:

- Magic number	(4 bytes)
- Message ID (4 bytes)
- Data size (4 bytes)
- Version (2 bytes)
- Type (1 byte)
- Flag (1 byte)
- Service ID (4 bytes)
- Object ID (4 bytes)
- Action ID (4 bytes)
"
Class {
	#name : #QiMessage,
	#superclass : #Object,
	#instVars : [
		'id',
		'size',
		'type',
		'flags',
		'service',
		'object',
		'action',
		'payload'
	],
	#classInstVars : [
		'counter'
	],
	#category : #'QiMessaging-Core'
}

{ #category : #'instance creation' }
QiMessage class >> actionNotFound: aQiMessage [
	"Return a QiMessage to respond to this message if the object is not found."
	"TODO: a QiValue should be returned instead of a String."
	aQiMessage payload: 'Action not found'.
	aQiMessage type: self typeError.
	^aQiMessage.
]

{ #category : #'instance creation' }
QiMessage class >> createFromBytes: bytes [
	| message |
	message := self fromHeader: bytes.
	message payload: (bytes copyFrom: 29 to: 28 + message size).
	^message
]

{ #category : #'instance creation' }
QiMessage class >> flagNone [
	^ 0
]

{ #category : #'instance creation' }
QiMessage class >> fromHeader: bytes [
	| magic message version |
	bytes byteSize < 28 ifTrue: [ ^ self error: 'message smaller than header size' ].
	magic := bytes unsignedLongAt: 1 bigEndian: true.
	magic = self magic ifFalse: [ ^ self error: 'Invalid magic number' ].
	message := self new.
	message id: (bytes unsignedLongAt: 5 bigEndian: false).
	message size: (bytes unsignedLongAt: 9 bigEndian: false).
	version := (bytes unsignedShortAt: 13 bigEndian: false).
	version = 0 ifFalse: [ ^ self error: 'invalid protocol version' ].
	message type: (bytes unsignedCharAt: 15) asInteger; flags: (bytes unsignedCharAt: 16) asInteger.
	message service: (bytes unsignedLongAt: 17 bigEndian: false).
	message object: (bytes unsignedLongAt: 21 bigEndian: false).
	message action: (bytes unsignedLongAt: 25 bigEndian: false).
	^message
]

{ #category : #accessing }
QiMessage class >> magic [
   "42dead42"
	^	1121889602
]

{ #category : #initialize }
QiMessage class >> maxSize [
	^ 1024 * 1024 * 50
]

{ #category : #'instance creation' }
QiMessage class >> newUniqueId [
	counter ifNil: [ counter := 0 ].
	counter := counter + 1.
	^ self new id: counter
]

{ #category : #'instance creation' }
QiMessage class >> objectNotFound: aQiMessage [
	"Return a QiMessage to respond to this message if the object is not found."
	"TODO: a QiValue should be returned instead of a String."
	aQiMessage payload: 'Object not found'.
	aQiMessage type: self typeError.
	^aQiMessage.
]

{ #category : #'instance creation' }
QiMessage class >> serviceNotFound: aQiMessage [
	"Return a QiMessage to respond to this message if the object is not found."
	"TODO: a QiValue should be returned instead of a String."
	aQiMessage payload: 'Service not found'.
	aQiMessage type: self typeError.
	^aQiMessage.
]

{ #category : #'instance creation' }
QiMessage class >> typeCall [
	^ 1
]

{ #category : #'instance creation' }
QiMessage class >> typeCancel [
	^ 7
]

{ #category : #'instance creation' }
QiMessage class >> typeCancelled [
	^ 8
]

{ #category : #'instance creation' }
QiMessage class >> typeCapability [
	^ 6
]

{ #category : #'instance creation' }
QiMessage class >> typeError [
	^ 3
]

{ #category : #'instance creation' }
QiMessage class >> typeEvent [
	^ 5
]

{ #category : #'instance creation' }
QiMessage class >> typePost [
	^ 4
]

{ #category : #'instance creation' }
QiMessage class >> typeReply [
	^ 2
]

{ #category : #'instance creation' }
QiMessage class >> typeUnknown [
	^ 0
]

{ #category : #comparing }
QiMessage >> = anotherMessage [
	^ self equals: anotherMessage
]

{ #category : #accessing }
QiMessage >> action [
	^action
]

{ #category : #accessing }
QiMessage >> action: anActionId [
	action := anActionId.
]

{ #category : #accessing }
QiMessage >> data [
	|bytes |
	bytes := ByteArray new: 28 + self payloadSize.
	bytes unsignedLongAt: 1 put: self class magic bigEndian: true.
	bytes unsignedLongAt: 5 put: self id bigEndian: false.
	bytes unsignedLongAt: 9 put: self payloadSize bigEndian: false.
	bytes unsignedShortAt: 13 put: self version bigEndian: false.
	bytes unsignedCharAt: 15 put:	self type.
	bytes unsignedCharAt: 16 put:	self flags.
	bytes unsignedLongAt: 17 put: self service bigEndian: false.
	bytes unsignedLongAt: 21 put: self object bigEndian: false.
	bytes unsignedLongAt: 25 put: self action bigEndian: false.
	bytes replaceFrom: 29 to: 28 + self payload size with: self payload startingAt: 1.
	^bytes
]

{ #category : #comparing }
QiMessage >> equals: anotherMessage [
	| fields |
	fields := #( #id #flags #type #size #service #object #action #payload).
	^ (fields anySatisfy: [ :symbol |
		| a b |
		a := self perform: symbol.
		b := anotherMessage perform: symbol.
		a ~= b]) not.

]

{ #category : #accessing }
QiMessage >> flags [
	^flags
]

{ #category : #accessing }
QiMessage >> flags: aChar [
 	flags := aChar.
]

{ #category : #accessing }
QiMessage >> headerSize [
	^24
]

{ #category : #accessing }
QiMessage >> id [
	^id
]

{ #category : #accessing }
QiMessage >> id: anId [
	id := anId.
]

{ #category : #initialization }
QiMessage >> initialize [ 
	id := 0.	
	flags := 0.
	type := 0.
	service := 0.
	action := 0.
	object := 0.
	payload := ByteArray new.
]

{ #category : #accessing }
QiMessage >> isHeaderValid [
	^self version equals: 0.
]

{ #category : #accessing }
QiMessage >> object [
	^object
]

{ #category : #accessing }
QiMessage >> object: anObjectId [
	object := anObjectId.
]

{ #category : #accessing }
QiMessage >> payload [
	^payload
]

{ #category : #accessing }
QiMessage >> payload: aByteArray [
	payload := aByteArray.
	size := aByteArray size.
]

{ #category : #accessing }
QiMessage >> payloadSize [
	^ payload ifNil: [ 0 ] ifNotNil: [ payload size ]
]

{ #category : #accessing }
QiMessage >> service [
	^service
]

{ #category : #accessing }
QiMessage >> service: aServiceId [
	service := aServiceId.
]

{ #category : #accessing }
QiMessage >> size [
	^ size
]

{ #category : #accessing }
QiMessage >> size: aNumber [
	size := aNumber
]

{ #category : #accessing }
QiMessage >> type [
	^type
]

{ #category : #accessing }
QiMessage >> type: aChar [
	type := aChar.
]

{ #category : #accessing }
QiMessage >> version [
	"Returns the protocol version"
	^0
]
