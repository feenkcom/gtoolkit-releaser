"
I compiled the Metacello baseline of a project release based on the new version numbers of its child releases. I should be applied on a project release, not on a repository release. 

See {{gtMethod:GtRlProjectRelease>>#compileBaselineMethod}} for more implementation details.


"
Class {
	#name : #GtRlCompileBaselineReleaseAction,
	#superclass : #GtRlReleaseAction,
	#instVars : [
		'projectRelease'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #'instance creation' }
GtRlCompileBaselineReleaseAction class >> forProjectRelease: aProjectRelease [
	^ self new
		projectRelease: aProjectRelease
]

{ #category : #'private - ui' }
GtRlCompileBaselineReleaseAction >> baselineCodeForCommit: aCommit [
	| baselineName baselinePackageName icebergBaselinePackage mcPackage baselineDefinition |
	baselineName := self projectRelease project baselineClass name.
	baselinePackageName := self projectRelease project baselineClass package name.
	icebergBaselinePackage := aCommit packages 
		detect: [ :aPackage | aPackage name = baselinePackageName ] 
		ifNone: [ ^ nil ].
	mcPackage := aCommit snapshotFor: icebergBaselinePackage.
	baselineDefinition := mcPackage definitions 
		detect: [ :e | 
			e isMethodDefinition and: [ 
				e selector = 'baseline:' and: [ 
					e className = baselineName ] ] ]
		ifNone: [ ^ nil ].
	^ baselineDefinition source
]

{ #category : #printing }
GtRlCompileBaselineReleaseAction >> description [
	^ 'Compile baseline ', self projectRelease project baselineClass name
]

{ #category : #printing }
GtRlCompileBaselineReleaseAction >> descriptionDetails [
	^ self projectRelease project baselineClass name
]

{ #category : #ui }
GtRlCompileBaselineReleaseAction >> gtGeneratedSourceFor: aView [
	<gtView> 
	^ self projectRelease 
		ifNil: [ aView ]
		ifNotNil: [ self projectRelease gtGeneratedSourceFor: aView ]
]

{ #category : #ui }
GtRlCompileBaselineReleaseAction >> gtViewBaselineSourceDiffFor: aView [
	<gtView>
	self projectRelease ifNil: [ ^ aView ].
	^ aView explicit
		title: 'Diff current baseline' translated;
		priority: 20;
		stencil: [ :anEditor | 
			| change |
			change := GtDiffBuilder
					computeDifferencesFrom: (self projectRelease project baselineClass
							>> #baseline:) sourceCode
					to: self projectRelease generateBaselineSource
					using: GtCharacterGroupDiffSplitter words.
			GtDiffElementWithLabelStencil new
				fromLabelText: 'Current baseline:';
				toLabelText: 'Release baseline:';
				change: change;
				styler: (GtCodeDiffRBTextStyler new
						isForWorkspace: false;
						yourself) ]
]

{ #category : #ui }
GtRlCompileBaselineReleaseAction >> gtViewPreviousVersionDiffFor: aView [
	<gtView>
	self projectRelease ifNil: [ ^ aView ].
	self projectRelease repositoryRelease semanticVersionTags ifEmpty: [ ^ self ].

	^ aView explicit
		title: 'Diff previous version' translated;
		priority: 20;
		stencil: [ :anEditor | 
			| latestTag originalCode change |
			latestTag := self projectRelease repositoryRelease latestSemanticVersionTag.
			originalCode := self baselineCodeForCommit: latestTag commit.
			change := GtDiffBuilder
					computeDifferencesFrom: (originalCode ifNil: [ '' ])
					to: self projectRelease generateBaselineSource
					using: GtCharacterGroupDiffSplitter words.
			(GtDiffElement onChange: change) aptitude: GtDiffShadowAptitude ];
		stencil: [ | latestTag originalCode change |
			latestTag := self projectRelease repositoryRelease latestSemanticVersionTag.
			originalCode := self baselineCodeForCommit: latestTag commit.
			change := GtDiffBuilder
					computeDifferencesFrom: (originalCode ifNil: [ '' ])
					to: self projectRelease generateBaselineSource
					using: GtCharacterGroupDiffSplitter words.
			GtDiffElementWithLabelStencil new
				fromLabelText: 'Previous release baseline:';
				toLabelText: 'New release baseline:';
				change: change;
				styler: (GtCodeDiffRBTextStyler new
						isForWorkspace: false;
						yourself) ]
]

{ #category : #accessing }
GtRlCompileBaselineReleaseAction >> name [ 	
	^ 'Compile baseline'
]

{ #category : #actions }
GtRlCompileBaselineReleaseAction >> performAction [
	self projectRelease compileBaselineMethod
]

{ #category : #accessing }
GtRlCompileBaselineReleaseAction >> projectRelease [
	^ projectRelease
]

{ #category : #accessing }
GtRlCompileBaselineReleaseAction >> projectRelease: aProjectRelease [
	projectRelease := aProjectRelease
]

{ #category : #accessing }
GtRlCompileBaselineReleaseAction >> repositoryRelease [
	^ self projectRelease repositoryRelease
]
