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
	#category : #'QiMessaging-Core'
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
QiProxyObject >> callMessageforMethodId: aNumber withArguments: aCollection [
	| metaMethod payload actionId |
	metaMethod := metaObject methods at: aNumber.
	actionId := metaMethod uid.
	payload := metaMethod serializeParameters: aCollection.
	^ self newCallMessageForAction: actionId payload: payload.
]

{ #category : #'reflective operations' }
QiProxyObject >> callMethodId: aNumber withArguments: aCollection [
	| qiMessageCall qiMessageReply |
	qiMessageCall := self callMessageforMethodId: aNumber withArguments: aCollection.
	qiMessageReply := self callWithMessage: qiMessageCall.
	^ self prepareResponseTo: qiMessageReply
]

{ #category : #'reflective operations' }
QiProxyObject >> callWithMessage: aQiMessage [
	"Send aQiMessage and wait for an answer with the same message id."
	"Return a QiMessage."
	| response receiver |
	receiver := QiResponseReceiver new
		service: aQiMessage service;
		object: aQiMessage object;
		action: aQiMessage action;
		id: aQiMessage id.
	channel addReceiver: receiver.
	channel sendMessage: aQiMessage.
	response := receiver receiveMessage.
	channel removeReceiver: receiver.
	^ response
]

{ #category : #'reflective operations' }
QiProxyObject >> channel [
	"TODO: For debug, remove me."
	^ channel
]

{ #category : #'reflective operations' }
QiProxyObject >> doesNotUnderstand: aMessage [
	"TODO: rewrite me to compile the method"
	| messageName metaMethod payload actionId qiMessage response receiver |
	messageName := aMessage 	selector asString copyReplaceAll: ':' with: ''.
	metaMethod := metaObject findMetaMethod: messageName orElse: [
		^ MessageNotUnderstood new
		message: aMessage;
		receiver: self;
		signal].
	actionId := metaMethod uid.
	payload := metaMethod serializeParameters: aMessage arguments.
	qiMessage := self newCallMessageForAction: actionId payload: payload.
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
QiProxyObject >> newCallMessageForAction: aNumber payload: aByteArray [
	"Create a new QiMessage "
	^ QiMessage newUniqueId
		service: serviceId;
		object: objectId;
		action: aNumber;
		type: 	QiMessage typeCall;
		payload: aByteArray
]

{ #category : #'reflective operations' }
QiProxyObject >> prepareResponseTo: aQiMessage [

	aQiMessage type = QiMessage typeReply ifTrue: [
		| metaMethod |
		metaMethod := metaObject methods at: aQiMessage action.
		^ metaMethod deserializeResponse: aQiMessage payload
	].
	aQiMessage type = QiMessage typeEvent ifTrue: [ 
		| metaSignal |
		metaSignal := metaObject signals at: aQiMessage action.
		^ metaSignal deserializeResponse: aQiMessage payload
	].
	aQiMessage type = QiMessage typeError ifTrue: [ 
		| stream value |
		stream := ReadStream on: aQiMessage payload.
		value := QiValueSerializer new deserializeFrom: stream.
		^ value asError ].
	^ Error new signal:
		  'Unexpected response type' , aQiMessage type asString
]

{ #category : #'reflective operations' }
QiProxyObject >> registerEvent: objectNumber with: signalNumber with: aNumber [
	"registerEvent and unregisterEvent should not be called."
	"Per signal selector are generated instead like: onSignalNameDo:."
	^ SubclassResponsibility new signal
]

{ #category : #accessing }
QiProxyObject >> registerToSignal: aString with: aBlockWithOneArgument [
	"Register the event named aString."
	"Execute aBlock each time the signal is updated"
	| handler metaSignal signalId receiver registerEventActionId qiMessageCall qiMessageReply messageId 	continue |
	metaSignal := metaObject findMetaSignal: aString orElse: [ ^ Error new signal: 'Signal not found: ', aString ].
	signalId := metaSignal uid.
	handler := (1 to: SmallInteger maxVal) atRandom.
	
	"Here we would like to simply call:"
	"self registerEvent: objectId with: signalId with: handler."
	"But we need the message id sent, to listen to future event messages."
	"And the abstraction level at which registerEvent: lives does not provide acces to the message id."
	"There we have to manually handle this call in a similar fashion as callMethodId:withArguments:"
	registerEventActionId := 0.
	qiMessageCall := self callMessageforMethodId: registerEventActionId withArguments: { objectId. signalId. handler }.
	messageId := qiMessageCall id. "We have the messageId, we will be able to receive updates now."
	qiMessageReply := self callWithMessage: qiMessageCall.
	handler := self prepareResponseTo: qiMessageReply.


	receiver := QiResponseReceiver new
		service: serviceId;
		object: objectId;
		action: signalId;
		id:  messageId.
	channel addReceiver: receiver.
	"Process messages in the background until we receive an error (which can be a normal ending)."
	continue := true.
	[ [ continue ] whileTrue: [
		[
			| qiMessageEvent aQiValue |
			qiMessageEvent := receiver receiveMessage.
			[
				aQiValue := self prepareResponseTo: qiMessageEvent.
			] on: Error do:  [ :anError | 
				self halt.
			].
			aBlockWithOneArgument value: aQiValue.
		] on: Error do: [ :anError |
		continue := false.
		]
	] ] fork.
		
	^ QiCancelable new onCancel: [
		[ [ self unregisterEvent: objectId with: signalId with: handler ]
		ensure: [ channel removeReceiver: receiver. receiver stop: QiErrorStop new ] ] ]
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

{ #category : #'reflective operations' }
QiProxyObject >> unregisterEvent: objectNumber with: signalNumber with: aNumber [
	"registerEvent and unregisterEvent should not be called."
	"Per signal selector are generated instead like: onSignalNameDo:."
	^ ShouldNotImplement new signal
]
