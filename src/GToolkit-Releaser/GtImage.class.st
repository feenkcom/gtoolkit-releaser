Class {
	#name : #GtImage,
	#superclass : #Object,
	#instVars : [
		'version',
		'lastOpenedVersion',
		'timestamp'
	],
	#classInstVars : [
		'singleton'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #configuration }
GtImage class >> defaultPreferences [
	^ FileLocator preferences / 'pharo' / 'org.glamoroustoolkit.last-opened-version.ston'
]

{ #category : #'class initialization' }
GtImage class >> initialize [
	SessionManager default
		register: (ClassSessionHandler forClassNamed: self name)
		inCategory: SessionManager default systemCategory  
		atPriority: SessionManager default defaultPriority.
	
]

{ #category : #accessing }
GtImage class >> instance [ 
	singleton ifNil: [ 
	    singleton := self new.
	    singleton version: GtRlNullVersionNumber new.
	    singleton timestamp: DateAndTime now.
	].
	^ singleton
]

{ #category : #loading }
GtImage class >> loadLastOpenedVersion [
	| versionString |
	versionString := self defaultPreferences readStreamDo: [ :aReadStream | STON fromStream: aReadStream].
	^ GtRlSemanticVersionNumber createFromString: versionString.
]

{ #category : #accessing }
GtImage class >> reset [
	singleton := nil
]

{ #category : #'load and saving' }
GtImage class >> save: aValue into: aWriteStream [
	STON put: aValue onStreamPretty: (ZnCharacterWriteStream on: aWriteStream encoding: 'utf8')
]

{ #category : #'system startup' }
GtImage class >> startUp: resuming [
	| lastOpenedVersion |
	resuming
		ifFalse: [ ^ self ].
	self defaultPreferences exists
		ifFalse: [ self updateLastOpenedVersion.
			NonInteractiveTranscript stdout
				show: 'Preference file does not exist. Creating...' ].
	lastOpenedVersion := self loadLastOpenedVersion.
	NonInteractiveTranscript stdout
		show: 'Last opened version ';
		show: lastOpenedVersion printString.
	self instance lastOpenedVersion: lastOpenedVersion.
	self instance version > lastOpenedVersion
		ifTrue: [ self updateLastOpenedVersion ]
]

{ #category : #accessing }
GtImage class >> timestamp: aTimestamp [
	self instance timestamp: aTimestamp
]

{ #category : #'load and saving' }
GtImage class >> updateLastOpenedVersion [
	self defaultPreferences
		writeStreamDo:
			[ :aPreferenceStream | self save: self instance version versionString into: aPreferenceStream ].
	
]

{ #category : #accessing }
GtImage class >> version [
	^ self instance
]

{ #category : #accessing }
GtImage class >> version: aVersion [
	self instance version: aVersion
]

{ #category : #accessing }
GtImage >> gtPreviewFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		items: [ 
			{'GT version' -> self version versionString. 
			'GT release timestamp' -> self timestamp.
			'Image directory' -> Smalltalk image imageDirectory asFileReference.
			'Image format version' -> Smalltalk image imageFormatVersion.
			"'License' -> self licenseString."
			'VM' -> Smalltalk vm } ];
		column: 'Property' format: [:each | each key];
		column: 'Value' format: [:each | each value ];
		send: #value
]

{ #category : #accessing }
GtImage >> lastOpenedVersion [
	^ lastOpenedVersion. 
]

{ #category : #accessing }
GtImage >> lastOpenedVersion: anObject [
	lastOpenedVersion := anObject
]

{ #category : #accessing }
GtImage >> timestamp [
	^ timestamp
]

{ #category : #accessing }
GtImage >> timestamp: anObject [
	timestamp := anObject
]

{ #category : #accessing }
GtImage >> version [
	^ version
]

{ #category : #accessing }
GtImage >> version: anObject [
	version := anObject
]
