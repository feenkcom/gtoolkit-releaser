Class {
	#name : #GtRlIceMinimalRepository,
	#superclass : #Object,
	#instVars : [
		'name',
		'head',
		'tagDictionary',
		'remotes'
	],
	#category : #'GToolkit-Releaser-BaselineModel-MinimalIceberg'
}

{ #category : #adding }
GtRlIceMinimalRepository >> addRemote: aRemote [  
	"Add a remote to the current repository.
	
	Throw an exception if a remote with the same name already exists"
	
	(self hasRemoteNamed: aRemote name)
		ifTrue: [ IceRemoteAlreadyExistsError new
			remoteName: aRemote name;
			signal ].
	
	self remoteAt: aRemote name put: aRemote.
	aRemote localRepository: self.
]

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
GtRlIceMinimalRepository >> branchNamed: aName ifAbsent: bloc [
	
	head validateIsBranch.
	^ head
]

{ #category : #accessing }
GtRlIceMinimalRepository >> gtSemanticVersionsTags [
	^ self tags select: #gtIsSemanticVersion
]

{ #category : #testing }
GtRlIceMinimalRepository >> hasRemoteNamed: aString [ 
	
	self remoteNamed: aString ifAbsent: [ ^ false ].
	^ true
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
GtRlIceMinimalRepository >> remoteAt: aString put: aRemote [

	remotes at: aString put: aRemote
]

{ #category : #'API-remotes' }
GtRlIceMinimalRepository >> remoteNamed: aString ifAbsent: aBlockClosure [ 
	
	^ remotes at: aString ifAbsent: aBlockClosure
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
