Class {
	#name : #GtRlChecksRunnerStatsExamples,
	#superclass : #Object,
	#category : #'GToolkit-Releaser-ChecksRunner-Examples'
}

{ #category : #examples }
GtRlChecksRunnerStatsExamples >> updateAnnouncementsCaptureState [
	<gtExample>
	| stats announcements |
	stats := GtRlChecksRunnerStats new.
	announcements := OrderedCollection new.
	stats
		when: GtRlChecksRunnerUpdateAnnouncement
		do: [ :announcement | announcements add: announcement ]
		for: self.
	stats notifyUpdate.
	stats
		state: #running;
		notifyUpdate.
	self assert: announcements size equals: 2.
	self assert: announcements first state equals: #notStarted.
	self assert: announcements second state equals: #running.
	^ stats
]
