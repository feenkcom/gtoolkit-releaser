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

{ #category : #constants }
JenkinsClient class >> backgroundColorForStatus: aString [
	aString = 'SUCCESS' ifTrue: [^ BrGlamorousColors successBackgroundColor].
	aString = 'FAILURE' ifTrue: [^ BrGlamorousColors errorBackgroundColor].
	aString = 'UNSTABLE' ifTrue: [^ BrGlamorousColors failureBackgroundColor ].
	^ BrGlamorousColors lightBorderColor.
]

{ #category : #constants }
JenkinsClient class >> backgroundColorForTestStatus: aString [
	aString = 'PASSED' ifTrue: [^ BrGlamorousColors successBackgroundColor].
	aString = 'FAILED' ifTrue: [^ BrGlamorousColors failureBackgroundColor].
	^ BrGlamorousColors lightBorderColor.
]

{ #category : #constants }
JenkinsClient class >> borderColorForStatus: aString [
	aString = 'SUCCESS' ifTrue: [^ BrGlamorousColors successBorderColor].
	aString = 'FAILURE' ifTrue: [^ BrGlamorousColors errorBorderColor].
	aString = 'UNSTABLE' ifTrue: [^ BrGlamorousColors failureBorderColor ].
	^ BrGlamorousColors lightBorderColor.
]

{ #category : #constants }
JenkinsClient class >> borderColorForTestStatus: aString [
	aString = 'PASSED' ifTrue: [^ BrGlamorousColors successBorderColor].
	aString = 'FAILED' ifTrue: [^ BrGlamorousColors errorBorderColor].
	^ BrGlamorousColors lightBorderColor.
]

{ #category : #constants }
JenkinsClient class >> green [
	^ Color r: 100 g: 163 b: 56 range: 255
]

{ #category : #constants }
JenkinsClient class >> red [
	^ Color r: 224 g: 59 b: 36 range: 255
]

{ #category : #constants }
JenkinsClient class >> yellow [
	^ Color r: 255 g: 204 b: 0 range: 255
]

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
JenkinsClient >> blueOcean [
	|json codeGenerator model|
	self setupJwtToken.
	json := znclient get: ('' join:{url . '/blue/rest/organizations/jenkins/pipelines/feenkcom'}).
	codeGenerator := JSONCodeGenerator new.
	model := codeGenerator modelFrom: (NeoJSONReader fromString: json).
	model url: url.
	model znclient: znclient.
	^ model.
]

{ #category : #accessing }
JenkinsClient >> getJwtToken [
	| jwt |
	znclient get: ('' join: { url .'/jwt-auth/token'}).
	jwt := znclient response headers at:'X-Blueocean-Jwt'.
	znclient request headers removeKey: 'Authorization' ifAbsent: [].
	znclient request setAuthorization: 'Bearer ', jwt.
	"^ znclient request"
	^ znclient get: ('' join:{url . '/blue/rest/organizations/jenkins/pipelines/'})
	
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
JenkinsClient >> reasonForFailure [
	|org gtjob run text startIndex lineNumber|
	org := self allOrganizationJobsModel.
	gtjob:=(org jobs first jobs detect: [:j | j name = 'gtoolkit'])jobs first.
	run := (gtjob builds select: [:r | r result = 'FAILURE']) first.
	^ run reasonForFailure "text := run consoleText.
	startIndex := text findString: 'Pharo VM version:'.
	lineNumber := text lineNumberCorrespondingToIndex: startIndex .
	^ String lf join:(text lines copyFrom: lineNumber - 20 to: (text lines size))."
]

{ #category : #accessing }
JenkinsClient >> setupJwtToken [
	| jwt |
	znclient get: ('' join: { url .'/jwt-auth/token'}).
	jwt := znclient response headers at:'X-Blueocean-Jwt'.
	znclient request headers removeKey: 'Authorization' ifAbsent: [].
	znclient request setAuthorization: 'Bearer ', jwt.
	"^ znclient request"
	
	
]

{ #category : #accessing }
JenkinsClient >> username: anUsername token: aToken url: anUrl [
	znclient := ZnClient new
   username: anUsername password: aToken.
	url := anUrl.
]

{ #category : #accessing }
JenkinsClient >> znclient [
	^ znclient
]
