Class {
	#name : #GtImage,
	#superclass : #Object,
	#instVars : [
		'version',
		'timestamp'
	],
	#classInstVars : [
		'singleton'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtImage class >> instance [ 
	singleton ifNil: [ 
	    singleton := self new.
	    singleton version: GtRlNullVersionNumber new.
	    singleton timestamp: DateAndTime now.
	].
	^ singleton
]

{ #category : #accessing }
GtImage class >> reset [
	singleton := nil
]

{ #category : #accessing }
GtImage class >> timestamp: aTimestamp [
	self instance timestamp: aTimestamp
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
