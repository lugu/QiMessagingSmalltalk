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
	^ #(#(#(#RGMethodDefinition #(#QiMessage #equals: #false)) #'2022-08-01T23:41:02.715465+02:00') )
]
