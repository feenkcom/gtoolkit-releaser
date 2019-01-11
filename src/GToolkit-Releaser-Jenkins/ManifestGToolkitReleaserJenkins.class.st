"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestGToolkitReleaserJenkins,
	#superclass : #PackageManifest,
	#category : #'GToolkit-Releaser-Jenkins-Manifest'
}

{ #category : #'code-critics' }
ManifestGToolkitReleaserJenkins class >> ruleRBBadMessageRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#JSONCodeGenerator #modelFrom: #false)) #'2019-01-11T10:40:18.910567+02:00') #(#(#RGMethodDefinition #(#JSONCodeGenerator #setAttribute:toValue:inObject: #false)) #'2019-01-11T14:32:51.519682+02:00') )
]
