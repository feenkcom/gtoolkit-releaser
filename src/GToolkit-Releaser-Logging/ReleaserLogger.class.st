Class {
	#name : 'ReleaserLogger',
	#superclass : 'MemoryLogger',
	#category : 'GToolkit-Releaser-Logging'
}

{ #category : 'accessing' }
ReleaserLogger >> gtReleaserRecordingsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Releaser Recordings' translated;
		priority: 50;
		items: [ self recordings reverse ];
		column: 'Type' translated text: [ :each | each name ];
		column: 'Contents' translated 
			text: [ :each | String streamContents: [ :s | each printOneLineContentsOn: s ] ]
			width: 600;
		column: 'Timestamp' translated text: [ :each | each timestamp asString ]
]
