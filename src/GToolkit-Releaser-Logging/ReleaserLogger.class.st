Class {
	#name : #ReleaserLogger,
	#superclass : #MemoryLogger,
	#category : #'GToolkit-Releaser-Logging'
}

{ #category : #'as yet unclassified' }
ReleaserLogger >> gtReleaserRecordingsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Releaser Recordings' translated;
		priority: 50;
		items: [ self recordings reverse ];
		column: 'Type' translated do: [ :aColumn | 
			aColumn 
				item: [ :each | each name ]; 
				matchParent ];
		column: 'Contents' translated do: [ :aColumn | 
			aColumn 
				item: [ :each | String streamContents: [ :s | each printOneLineContentsOn: s ] ]; 
				width:600 ];
		column: 'Timestamp' translated do: [ :aColumn | 
			aColumn 
				item: [ :each | each timestamp asString ]; 
				matchParent ]


]
