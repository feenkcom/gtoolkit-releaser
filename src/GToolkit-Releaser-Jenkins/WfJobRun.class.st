Class {
	#name : #WfJobRun,
	#superclass : #JenkinsWFAPI,
	#instVars : [
		'startTimeMillis',
		'name',
		'id',
		'stages',
		'pauseDurationMillis',
		'status',
		'queueDurationMillis',
		'endTimeMillis',
		'durationMillis',
		'_self',
		'changesets'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generated-Wfapi'
}

{ #category : #accessing }
WfJobRun >> gtStagesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Stages' translated;
		priority: 10;
		items: [ stages ];
		column: 'Name' translated do: [ :aColumn | 
			aColumn 
				item: [ :job | job name ]; 
				matchParent ];
		column: 'Status' translated do: [ :aColumn | 
			aColumn 
				item: [ :job | job status ]; 
				matchParent ];
		column: 'ID' translated do: [ :aColumn | 
			aColumn 
				item: [ :job | job id ]; 
				matchParent ]
]

{ #category : #accessing }
WfJobRun >> name [
	^ name
]

{ #category : #accessing }
WfJobRun >> status [
	^ status
]
