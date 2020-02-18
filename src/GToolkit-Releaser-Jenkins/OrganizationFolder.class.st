Class {
	#name : #OrganizationFolder,
	#superclass : #JenkinsURL,
	#instVars : [
		'_name',
		'_parent',
		'_jobs'
	],
	#classVars : [
		'jobs'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generated-JenkinsBranch'
}

{ #category : #accessing }
OrganizationFolder >> allJobsResponse [
	"jobs ifNil: [ "
	jobs := self znclient get: ('' join: { url . '/api/json?tree=jobs[name,jobs[name,branches[name]]]'}).
	"]."
	^ jobs
]

{ #category : #accessing }
OrganizationFolder >> gtJobsFor: aView [
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
OrganizationFolder >> jobs [
	^ _jobs
]

{ #category : #accessing }
OrganizationFolder >> name [
	^ _name
]

{ #category : #accessing }
OrganizationFolder >> parent [
	^ _parent
]

{ #category : #accessing }
OrganizationFolder >> url [
	^ self parent url,'/job/', self name
]

{ #category : #accessing }
OrganizationFolder >> znclient [ 
	^ _parent znclient 
]
