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
JenkinsClient >> allOrganizationJobs [
	| codeGenerator model |
	codeGenerator := JSONCodeGenerator new.
	jobs := znclient get: ('' join: { url . '/api/json?tree=jobs[name,jobs[name]]&pretty=true'}).
	model := codeGenerator modelFrom: (NeoJSONReader fromString: jobs).
	model url: url.
	model znclient: znclient.
	^ model.
]

{ #category : #accessing }
JenkinsClient >> allOrganizationJobsModel [
	| codeGenerator model |
	codeGenerator := JSONCodeGenerator new.
	jobs := znclient get: ('' join: { url . '/api/json?tree=jobs[name,jobs[name,jobs[name,builds[id,result,timestamp,url]]]]&pretty=true'}).
	model := codeGenerator modelFrom: (NeoJSONReader fromString: jobs) znclient: znclient.
	model url: url.
	model znclient: znclient.
	^ model.
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
JenkinsClient >> jobs [
	jobs ifNil: [ 
		jobs := znclient get: ('' join: { url . '/api/json?tree=jobs[name]&pretty=true'}).
	].
	^ jobs
]

{ #category : #accessing }
JenkinsClient >> model [
	| codeGenerator model |
	codeGenerator := JSONCodeGenerator new.
	jobs := znclient get: ('' join: { url . '/api/json?tree=jobs[name]&pretty=true'}).
	model := codeGenerator modelFrom: (NeoJSONReader fromString: jobs).
	model url: url.
	model znclient: znclient.
	^ model.
]

{ #category : #accessing }
JenkinsClient >> username: anUsername token: aToken url: anUrl [
	znclient := ZnClient new
   username: anUsername password: aToken.
	url := anUrl.
]
