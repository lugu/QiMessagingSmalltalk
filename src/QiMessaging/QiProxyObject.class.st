"
I represent a remote instance of an object.

When you invoke my methods, I serialize the arguments and send a message over a QiChannel. The remote object receives the message and respond. When I receive the message I return you the response.

Properties and signals are not yet supported.
"
Class {
	#name : #QiProxyObject,
	#superclass : #Object,
	#instVars : [
		'channel',
		'serviceId',
		'objectId',
		'metaObject'
	],
	#category : #QiMessaging
}

{ #category : #'instance creation' }
QiProxyObject class >> new: aQiChannel serviceId: aNumber objectId: anotherNumber metaObject: aQiMetaObject [
	^ self new initialize: aQiChannel serviceId: aNumber objectId: anotherNumber metaObject: aQiMetaObject.
]

{ #category : #'instance creation' }
QiProxyObject class >> newBasicObject: aQiChannel serviceId: aNumber objectId: anotherNumber [

	| class |
	class := QiMetaObject basicObject createProxyClassNamed:
		         'BasicObject'.
	^ class new
		  initialize: aQiChannel
		  serviceId: aNumber
		  objectId: anotherNumber
		  metaObject: QiMetaObject basicObject
]

{ #category : #'instance creation' }
QiProxyObject class >> newWithName: aString channel: aQiChannel serviceId: aNumber objectId: anotherNumber metaObject: aQiMetaObject [
	| class |
	class := aQiMetaObject createProxyClassNamed: aString.
	^ class new initialize: aQiChannel serviceId: aNumber objectId: anotherNumber metaObject: aQiMetaObject.
]

{ #category : #'reflective operations' }
QiProxyObject >> callMethodId: aNumber withArguments: aCollection [
	| metaMethod payload actionId qiMessage response receiver |
	metaMethod := metaObject methods at: aNumber.
	actionId := metaMethod uid.
	payload := metaMethod serializeParameters: aCollection.
	qiMessage := self newMessageForAction: actionId payload: payload.
	receiver := QiResponseReceiver new
		service: qiMessage service;
		object: qiMessage object;
		action: qiMessage action;
		id: qiMessage id.
	channel addReceiver: receiver.
	channel sendMessage: qiMessage.
	response := receiver receiveMessage.
	channel removeReceiver: receiver.
	response type = QiMessage typeReply ifTrue: [
		^ metaMethod deserializeResponse: response payload
	].
	response type = QiMessage typeError ifTrue: [
		| stream value |
		stream := ReadStream on: response payload.
		value := QiValueSerializer new deserializeFrom: stream.
		^ value asError.
	].
	^ Error new signal: 'Unexpected response type', response type asString.
]

{ #category : #'reflective operations' }
QiProxyObject >> doesNotUnderstand: aMessage [
	"TODO: rewrite me to compile the method"
	| messageName metaMethod payload actionId qiMessage response receiver |
	messageName := aMessage 	selector asString copyReplaceAll: ':' with: ''.
	metaMethod := metaObject findMethod: messageName orElse: [
		^ MessageNotUnderstood new
		message: aMessage;
		receiver: self;
		signal].
	actionId := metaMethod uid.
	payload := metaMethod serializeParameters: aMessage arguments.
	qiMessage := self newMessageForAction: actionId payload: payload.
	receiver := QiResponseReceiver new
		service: qiMessage service;
		object: qiMessage object;
		action: qiMessage action;
		id: qiMessage id.
	channel addReceiver: receiver.
	channel sendMessage: qiMessage.
	response := receiver receiveMessage.
	channel removeReceiver: receiver.
	response type = QiMessage typeReply ifTrue: [
		^ metaMethod deserializeResponse: response payload
	].
	response type = QiMessage typeError ifTrue: [
		| stream value |
		stream := ReadStream on: response payload.
		value := QiValueSerializer new deserializeFrom: stream.
		^ value asError.
	].
	^ Error new signal: 'Unexpected response type', response type asString.
]

{ #category : #accessing }
QiProxyObject >> initialize: aQiChannel serviceId: aNumber objectId: anotherNumber metaObject: aQiMetaObject [
	channel := aQiChannel.
	serviceId := aNumber.
	objectId := anotherNumber.
	metaObject := aQiMetaObject.
]

{ #category : #accessing }
QiProxyObject >> isConnected [

	^ channel isConnected
]

{ #category : #'reflective operations' }
QiProxyObject >> newMessageForAction: aNumber payload: aByteArray [
	"Create a new QiMessage "
	^ QiMessage newUniqueId
		service: serviceId;
		object: objectId;
		action: aNumber;
		type: 	QiMessage typeCall;
		payload: aByteArray
]

{ #category : #accessing }
QiProxyObject >> reifyInto: aString [
	"Update the description of the object."
	"Contacts the remote object to retreive the MetaObject"
	"With the complete MetaObject, the proxy can respond to more methods and signals."
	"Notice: self metaObject: is itself a method generated from the current metaObject."
	| aQimMetaObject me |
	aQimMetaObject := self metaObject: objectId.
	metaObject fromQiSlot: aQimMetaObject.
	me := self class newWithName: aString channel: channel serviceId: serviceId objectId: objectId metaObject: metaObject.
	^ me
]
