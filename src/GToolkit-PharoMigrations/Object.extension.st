Extension { #name : #Object }

{ #category : #'*GToolkit-PharoMigrations' }
Object >> forPharo12AndNewer: pharo12OrNewerBlock forPharo11: pharo11Block [
	"Evaluate one of the blocks based on the pharo's major version"
	| unsupportedVersionBlock |
	
	unsupportedVersionBlock := [
		self error: 'Unsupported pharo version: ',SystemVersion current major asString ].
	
	^ self
		forPharo14: pharo12OrNewerBlock 
		forPharo13: pharo12OrNewerBlock
		forPharo12: pharo12OrNewerBlock 
		forPharo11: pharo11Block
		newer: pharo12OrNewerBlock
		older: unsupportedVersionBlock
]

{ #category : #'*GToolkit-PharoMigrations' }
Object >> forPharo13AndNewer: pharo13OrNewerBlock forPharo12: pharo12Block forPharo11: pharo11Block [
	"Evaluate one of the blocks based on the pharo's major version"
	| unsupportedVersionBlock |
	
	unsupportedVersionBlock := [
		self error: 'Unsupported pharo version: ',SystemVersion current major asString ].
	
	^ self
		forPharo14: pharo13OrNewerBlock 
		forPharo13: pharo13OrNewerBlock
		forPharo12: pharo12Block 
		forPharo11: pharo11Block
		newer: pharo13OrNewerBlock
		older: unsupportedVersionBlock
]

{ #category : #'*GToolkit-PharoMigrations' }
Object >> forPharo14: pharo14Block forPharo13: pharo13Block forPharo12: pharo12Block forPharo11: pharo11Block [
	"Evaluate one of the blocks based on the pharo's major version"
	| unsupportedVersionBlock |
	
	unsupportedVersionBlock := [
		self error: 'Unsupported pharo version: ',SystemVersion current major asString ].
	
	^ self
		forPharo14: pharo14Block 
		forPharo13: pharo13Block
		forPharo12: pharo12Block 
		forPharo11: pharo11Block
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
