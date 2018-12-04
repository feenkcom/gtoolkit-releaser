Class {
	#name : #BaselineOfGToolkitReleaser,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkitReleaser
}

{ #category : #baseline }
BaselineOfGToolkitReleaser >> baseline: spec [
	<baseline>
		spec for: #common do: [ 
		spec
			package: 'GToolkit-Releaser';
			package: 'GToolkit-Releaser-IcebergExtensions' with: [ spec requires: #(GToolkit-Releaser) ] ]
]
