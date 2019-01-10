Class {
	#name : #GtRlIceMinimalRepository,
	#superclass : #Object,
	#instVars : [
		'name',
		'head',
		'tagDictionary',
		'remotes'
	],
	#category : #'GToolkit-Releaser-Examples'
}

{ #category : #accessing }
GtRlIceMinimalRepository >> branch [
	
	head validateIsBranch.
	^ head
]

{ #category : #accessing }
GtRlIceMinimalRepository >> branchName [
	"Returns current branch name.
	
	Throws an exception if HEAD is not a branch"

	^ self branch name
]

{ #category : #accessing }
GtRlIceMinimalRepository >> gtSemanticVersionsTags [
	^ self tags select: #gtIsSemanticVersion
]

{ #category : #accessing }
GtRlIceMinimalRepository >> head [
	^ head
]

{ #category : #initialization }
GtRlIceMinimalRepository >> initialize [
	super initialize.
	
	tagDictionary := Dictionary new.
	remotes := Dictionary new
]

{ #category : #accessing }
GtRlIceMinimalRepository >> name [
	^ name
]

{ #category : #accessing }
GtRlIceMinimalRepository >> name: aString [
	name := aString
]

{ #category : #accessing }
GtRlIceMinimalRepository >> remotes [
	^ remotes values
]

{ #category : #accessing }
GtRlIceMinimalRepository >> setHead: aCommitish [

	head := aCommitish
]

{ #category : #'API-tags' }
GtRlIceMinimalRepository >> tags [
	^ tagDictionary keys collect: [ :k | IceTag named: k inRepository: self ]
]
