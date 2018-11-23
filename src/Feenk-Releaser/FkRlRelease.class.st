Class {
	#name : #FkRlRelease,
	#superclass : #Object,
	#instVars : [
		'branchName',
		'semanticVersion'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #accessing }
FkRlRelease >> branchName [
	^ branchName
]

{ #category : #accessing }
FkRlRelease >> branchName: aBranchName [
	branchName := aBranchName
]

{ #category : #accessing }
FkRlRelease >> semanticVersion [
	^ semanticVersion
]

{ #category : #accessing }
FkRlRelease >> semanticVersion: aSemanticVersion [
	semanticVersion := aSemanticVersion
]
