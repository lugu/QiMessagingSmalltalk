"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestQiMessaging,
	#superclass : #PackageManifest,
	#category : #'QiMessaging-Manifest'
}

{ #category : #'code-critics' }
ManifestQiMessaging class >> ruleBadMessageRule2V1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#QiMessage #equals: #false)) #'2022-08-01T23:41:02.715465+02:00') #(#(#RGMethodDefinition #(#QiValue #serializeValueOnly #false)) #'2022-08-04T00:04:32.316271+02:00') #(#(#RGMethodDefinition #(#QiValue #serializeValueOnly: #false)) #'2022-08-04T00:19:34.88846+02:00') #(#(#RGMethodDefinition #(#QiValue #deserializeValue: #false)) #'2022-08-04T01:08:20.548023+02:00') #(#(#RGMethodDefinition #(#QiBasicSerializer #deserialize:from: #false)) #'2022-08-05T00:53:13.345811+02:00') #(#(#RGMethodDefinition #(#QiBasicSerializer #deserializeFrom: #false)) #'2022-08-05T00:55:40.128312+02:00') #(#(#RGMethodDefinition #(#QiBasicSerializer #serialize:into: #false)) #'2022-08-05T00:59:28.714112+02:00') #(#(#RGMethodDefinition #(#QiSession #authenticate: #false)) #'2022-08-12T22:44:35.237993+02:00') )
]

{ #category : #'code-critics' }
ManifestQiMessaging class >> ruleExcessiveVariablesRuleV1FalsePositive [
	^ #(#(#(#RGClassDefinition #(#QiSignatureParser)) #'2022-08-13T21:47:09.361837+02:00') )
]

{ #category : #'code-critics' }
ManifestQiMessaging class >> ruleSentNotImplementedRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#QiSession #service: #false)) #'2022-08-12T23:19:34.675503+02:00') )
]

{ #category : #'code-critics' }
ManifestQiMessaging class >> ruleUtilityMethodsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#QiBasicSerializer #serializeBoolean:into: #false)) #'2022-08-05T23:03:55.518478+02:00') #(#(#RGMethodDefinition #(#QiBasicSerializer #deserializeBooleanFrom: #false)) #'2022-08-05T23:04:42.381898+02:00') #(#(#RGMethodDefinition #(#QiValueSerializer #deserializeValue: #false)) #'2022-08-08T00:40:35.149126+02:00') #(#(#RGMethodDefinition #(#QiValueSerializer #serialize:into: #false)) #'2022-08-08T00:43:55.996604+02:00') #(#(#RGMethodDefinition #(#QiValueSerializer #deserializeFrom: #false)) #'2022-08-08T00:46:16.773058+02:00') #(#(#RGMethodDefinition #(#QiReceiver #stop: #false)) #'2022-08-11T23:41:03.676166+02:00') )
]
