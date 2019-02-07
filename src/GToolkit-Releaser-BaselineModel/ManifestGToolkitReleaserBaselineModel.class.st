"
I store metadata for this package used by various other tools.
"
Class {
	#name : #ManifestGToolkitReleaserBaselineModel,
	#superclass : #PackageManifest,
	#category : #'GToolkit-Releaser-BaselineModel-Manifest'
}

{ #category : #'meta-data' }
ManifestGToolkitReleaserBaselineModel class >> description [
	^ 'I contain a model for capturing Metacello baselines and dependencies between baselines.'
]
