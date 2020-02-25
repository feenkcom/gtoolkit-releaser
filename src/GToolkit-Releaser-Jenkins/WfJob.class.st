Class {
	#name : #WfJob,
	#superclass : #JenkinsWFAPI,
	#instVars : [
		'name',
		'runCount',
		'runs',
		'_self'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generated-Wfapi'
}

{ #category : #accessing }
WfJob >> gtRunsFor: aView [
	<gtView>
	self getLinks.
	^ aView columnedList
		title: 'Runs' translated;
		priority: 10;
		items: [ runs ];
		column: 'Name' translated do: [ :aColumn | 
			aColumn 
				item: [ :job | job name ]; 
				matchParent ];
		column: 'Status' translated do: [ :aColumn | 
			aColumn 
				item: [ :job | job status ]; 
				matchParent ]
]
