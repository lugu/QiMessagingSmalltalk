"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestQiMessagingTests,
	#superclass : #PackageManifest,
	#category : #'QiMessaging-Tests-Manifest'
}

{ #category : #'code-critics' }
ManifestQiMessagingTests class >> ruleSentNotImplementedRuleV1FalsePositive [
	^ #(#(#(#RGClassDefinition #(#QiProxyTest)) #'2022-08-12T00:31:43.37548+02:00') )
]

{ #category : #'code-critics' }
ManifestQiMessagingTests class >> ruleTempsReadBeforeWrittenRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#QiChannelTest #testSend #false)) #'2022-08-07T21:28:24.140673+02:00') )
]
