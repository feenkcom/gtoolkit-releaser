Class {
	#name : #BaselineOfGToolkitReleaserUI,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkitReleaserUI
}

{ #category : #baseline }
BaselineOfGToolkitReleaserUI >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec baseline: 'GToolkitReleaser' with: [ 
				spec repository: 'github://feenkcom/gtoolkit-releaser:main/src' ].
		spec baseline: 'GToolkitVisualizer' with: [
				spec repository: 'github://feenkcom/gtoolkit-visualizer:main/src' ].
		spec baseline: 'GToolkitInspector' with: [ 
				spec repository: 'github://feenkcom/gtoolkit-inspector:main/src' ].
		spec baseline: 'GToolkitSpotter' with: [ 
				spec repository: 'github://feenkcom/gtoolkit-spotter:main/src' ].
		spec baseline: 'LepiterEngineCore' with: [
				spec repository: 'github://feenkcom/lepiter:main/src' ].
				
		spec package: 'GToolkit-Releaser-UI' with: [
				spec requires: #(
					'GToolkitReleaser' 'GToolkitVisualizer' 
					'GToolkitInspector' 'GToolkitSpotter'
					'LepiterEngineCore'). ]. ].

]
