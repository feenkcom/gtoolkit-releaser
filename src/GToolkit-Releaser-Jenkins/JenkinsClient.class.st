Class {
	#name : #JenkinsClient,
	#superclass : #Object,
	#instVars : [
		'username',
		'token',
		'url',
		'jobs',
		'znclient'
	],
	#category : #'GToolkit-Releaser-Jenkins-Model'
}

{ #category : #accessing }
JenkinsClient >> allJobsResponse [
	jobs ifNil: [ 
		jobs := znclient get: ('' join: { url . '/api/json?tree=jobs[name]&pretty=true'}).
	].
	^ jobs
]

{ #category : #accessing }
JenkinsClient >> gtJobsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Jobs' translated;
		priority: 10;
		items: [ self jobs ];
		column: 'Name' translated do: [ :aColumn | 
			aColumn 
				item: [ :job | job name ]; 
				matchParent ];
		column: 'URL' translated do: [ :aColumn | 
			aColumn 
				item: [ :job | job url ]; 
				matchParent ]
]

{ #category : #accessing }
JenkinsClient >> model [
	| codeGenerator |
	codeGenerator := JSONCodeGenerator new.
	jobs := znclient get: ('' join: { url . '/api/json?tree=jobs[name]&pretty=true'}).
	^ codeGenerator modelFrom: (NeoJSONReader fromString: jobs)
]

{ #category : #accessing }
JenkinsClient >> username: anUsername token: aToken url: anUrl [
	znclient := ZnClient new
   username: anUsername password: aToken.
	url := anUrl.
]
