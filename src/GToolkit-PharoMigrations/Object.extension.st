Extension { #name : #Object }

{ #category : #'*GToolkit-PharoMigrations' }
Object >> forPharo12: pharo12Block forPharo11: pharo11Block forPharo10: pharo10Block [
	"Evaluate one of the blocks based on the pharo's major version"
	| unsupportedVersionBlock |
	
	unsupportedVersionBlock := [
		self error: 'Unsupported pharo version: ',SystemVersion current major asString ].
	
	^ self
		forPharo12: pharo12Block
		forPharo11: pharo11Block
		forPharo10: pharo10Block
		newer: unsupportedVersionBlock
		older: unsupportedVersionBlock
]

{ #category : #'*GToolkit-PharoMigrations' }
Object >> forPharo12: pharo12Block forPharo11: pharo11Block forPharo10: pharo10Block newer: newerBlock older: olderBlock [
	"Evaluate one of the blocks based on the pharo's major version"
	
	SystemVersion current major > 12
		ifTrue: [ ^ newerBlock value ].

	SystemVersion current major = 12
		ifTrue: [ ^ pharo12Block value ].
	SystemVersion current major = 11
		ifTrue: [ ^ pharo11Block value ].
	SystemVersion current major = 10
		ifTrue: [ ^ pharo10Block value ].

	^ olderBlock value
]

{ #category : #'*GToolkit-PharoMigrations' }
Object >> forPharo12: pharo12Block forPharo11AndPharo10: pharo11AndPharo10Block [
	"Evaluate one of the blocks based on the pharo's major version"
	| unsupportedVersionBlock |
	
	unsupportedVersionBlock := [
		self error: 'Unsupported pharo version: ',SystemVersion current major asString ].
	
	^ self
		forPharo12: pharo12Block
		forPharo11: pharo11AndPharo10Block
		forPharo10: pharo11AndPharo10Block
		newer: unsupportedVersionBlock
		older: unsupportedVersionBlock
]

{ #category : #'*GToolkit-PharoMigrations' }
Object >> forPharo14: pharo14Block forPharo13: pharo13Block forPharo12: pharo12Block forPharo11: pharo11Block  newer: newerBlock older: olderBlock [
	"Evaluate one of the blocks based on the pharo's major version"
	
	SystemVersion current major > 14
		ifTrue: [ ^ newerBlock value ].

	SystemVersion current major = 14
		ifTrue: [ ^ pharo14Block value ].
	SystemVersion current major = 13
		ifTrue: [ ^ pharo13Block value ].
	SystemVersion current major = 12
		ifTrue: [ ^ pharo12Block value ].
	SystemVersion current major = 11
		ifTrue: [ ^ pharo11Block value ].

	^ olderBlock value
]
