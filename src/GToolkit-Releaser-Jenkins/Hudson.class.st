Class {
	#name : #Hudson,
	#superclass : #JenkinsURL,
	#instVars : [
		'jobs',
		'_jobs'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generated-HudsonModel'
}

{ #category : #accessing }
Hudson >> gtJobsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Jobs' translated;
		priority: 10;
		items: [ self jobs ];
		column: 'Name' translated do: [ :aColumn | 
			aColumn 
				item: [ :job | job name ]; 
				matchParent ]
]

{ #category : #accessing }
Hudson >> jobs [
	^ jobs
]
