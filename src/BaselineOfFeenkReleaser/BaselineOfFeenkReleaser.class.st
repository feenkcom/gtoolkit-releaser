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
			baseline: 'GToolkit' with: [ spec repository: 'github://feenkcom/gtoolkit/src' ];
			package: 'Feenk-Releaser' with: [ spec requires: #(GToolkit) ];
			package: 'Feenk-Releaser-IcebergExtensions' with: [ spec requires: #(Feenk-Releaser) ] ]
]
