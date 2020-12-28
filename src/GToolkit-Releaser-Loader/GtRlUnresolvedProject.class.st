Class {
	#name : #GtRlUnresolvedProject,
	#superclass : #Object,
	#instVars : [
		'name',
		'repository',
		'parentProjects',
		'projectReferences'
	],
	#category : #'GToolkit-Releaser-Loader'
}

{ #category : #adding }
GtRlUnresolvedProject >> addProjectReference: aProjectReference [
	self assert: [ aProjectReference notNil ].
	self assert: [ aProjectReference referencedProject notNil ].
	
	self projectReferences add: aProjectReference.
	aProjectReference parentProject: self.
	aProjectReference referencedProject basicAddParentProject: self.
]

{ #category : #adding }
GtRlUnresolvedProject >> addProjectReferences: aCollection [
	aCollection do: [ :aProjectReference | 
		self addProjectReference: aProjectReference ]
]

{ #category : #private }
GtRlUnresolvedProject >> basicAddParentProject: aParentProject [
	self parentProjects add: aParentProject
]

{ #category : #accessing }
GtRlUnresolvedProject >> childProjects [
	^ self projectReferences collect: [ :aProjectReference |
		aProjectReference referencedProject ]
]

{ #category : #initialization }
GtRlUnresolvedProject >> initialize [ 
	super initialize.
	parentProjects := OrderedCollection new.
	projectReferences := OrderedCollection new.
]

{ #category : #actions }
GtRlUnresolvedProject >> linkWithRepository: aRepository [
	self repository: aRepository.
	(GtRlProjectLinkWithRepositorySignal project: self repository: aRepository) emit.
	aRepository addProject: self
]

{ #category : #accessing }
GtRlUnresolvedProject >> name [
	^ name
]

{ #category : #accessing }
GtRlUnresolvedProject >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtRlUnresolvedProject >> parentProjects [
	^ parentProjects
]

{ #category : #printing }
GtRlUnresolvedProject >> printOn: aStream [
	super printOn: aStream.
	aStream 
		nextPutAll: '(';
		nextPutAll: self name;
		nextPutAll: ')'
]

{ #category : #accessing }
GtRlUnresolvedProject >> projectReferences [
	^ projectReferences
]

{ #category : #accessing }
GtRlUnresolvedProject >> repository [
	^ repository
]

{ #category : #accessing }
GtRlUnresolvedProject >> repository: anObject [
	repository := anObject
]
