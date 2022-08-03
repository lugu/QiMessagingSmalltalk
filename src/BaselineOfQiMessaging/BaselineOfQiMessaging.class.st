Class {
	#name : #BaselineOfQiMessaging,
	#superclass : #BaselineOf,
	#category : #BaselineOfQiMessaging
}

{ #category : #baselines }
BaselineOfQiMessaging >> baseline: spec [
	<baseline>
	spec
		for: #common
			do: [
				"Dependencies"
				self petitParser: spec.

				"Packages"
				spec
					package: 'QiMessaging';
					package: 'QiMessaging-Tests' with: [ spec requires: #('QiMessaging') ]
	]
]

{ #category : #baselines }
BaselineOfQiMessaging >> projectClass [
        ^ MetacelloCypressBaselineProject
]

{ #category : #baselines }
BaselineOfQiMessaging >> petitParser: spec [
	spec
		baseline: 'PetitParser'
		with: [ spec repository: 'github://moosetechnology/PetitParser:v2.2.0/src' ].
]
