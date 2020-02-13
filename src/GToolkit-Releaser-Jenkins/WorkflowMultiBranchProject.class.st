Class {
	#name : #WorkflowMultiBranchProject,
	#superclass : #JenkinsURL,
	#instVars : [
		'_name',
		'_parent',
		'_jobs'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generated-OrgJenkinsciPluginsWorkflowMultibranch'
}

{ #category : #accessing }
WorkflowMultiBranchProject >> gtJobsFor: aView [
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
WorkflowMultiBranchProject >> jobs [
	^ _jobs
]

{ #category : #accessing }
WorkflowMultiBranchProject >> name [
	^ _name
]

{ #category : #accessing }
WorkflowMultiBranchProject >> znclient [ 
	^ _parent znclient 
]
