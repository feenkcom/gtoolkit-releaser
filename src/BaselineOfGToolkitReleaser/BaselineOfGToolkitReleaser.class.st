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
			package: 'GToolkit-Releaser-BaselineModel';
			package: 'GToolkit-Releaser' with: [ spec requires: #('GToolkit-Releaser-BaselineModel') ];
			package: 'GToolkit-Releaser-IcebergExtensions' with: [ spec requires: #('GToolkit-Releaser') ];
			package: 'GToolkit-Releaser-ExamplesExplorer' with: [ spec requires: #('GToolkit-Releaser') ];
			package: 'GToolkit-Releaser-Logging';
			package: 'GToolkit-Releaser-Jenkins';
			package: 'GToolkit-Releaser-BaselineModel-SystemOneExamples';
			package: 'GToolkit-Releaser-BaselineModel-SystemThreeExamples';
			package: 'GToolkit-Releaser-BaselineModel-SystemTwoExamples';
			package: 'GToolkit-Releaser-BaselineModel-MinimalIceberg';
			package: 'GToolkit-Releaser-BaselineModel-Examples' with: [ spec requires: #('GToolkit-Releaser-BaselineModel-SystemOneExamples' 'GToolkit-Releaser-BaselineModel-SystemThreeExamples' 'GToolkit-Releaser-BaselineModel-SystemTwoExamples' 'GToolkit-Releaser-BaselineModel-MinimalIceberg') ];
			package: 'GToolkit-Releaser-Examples' with: [ spec requires: #('GToolkit-Releaser' 'GToolkit-Releaser-IcebergExtensions' 'GToolkit-Releaser-BaselineModel-Examples') ];
			package: 'GToolkit-Releaser-Wiki' with: [ spec requires: #('GToolkit-Releaser-Examples') ]. ].
]
