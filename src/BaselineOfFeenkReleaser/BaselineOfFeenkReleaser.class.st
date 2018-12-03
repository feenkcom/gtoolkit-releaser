Class {
	#name : #BaselineOfFeenkReleaser,
	#superclass : #BaselineOf,
	#category : #BaselineOfFeenkReleaser
}

{ #category : #baseline }
BaselineOfFeenkReleaser >> baseline: spec [
	<baseline>
		spec for: #common do: [ 
		spec
			package: 'Feenk-Releaser';
			package: 'Feenk-Releaser-IcebergExtensions' with: [ spec requires: #(Feenk-Releaser) ] ]
]
