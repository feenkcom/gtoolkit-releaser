Class {
	#name : #GtRlChecksRunnerUpdateAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'state'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlChecksRunnerUpdateAnnouncement >> state [
	<return: #Symbol>
	^ state
]

{ #category : #accessing }
GtRlChecksRunnerUpdateAnnouncement >> state: aSymbol [
	state := aSymbol
]
