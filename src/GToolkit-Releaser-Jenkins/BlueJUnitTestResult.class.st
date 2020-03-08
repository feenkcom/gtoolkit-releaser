Class {
	#name : #BlueJUnitTestResult,
	#superclass : #JenkinsURL,
	#instVars : [
		'_errorStackTrace',
		'_errorDetails',
		'_age',
		'_name',
		'_id',
		'_duration',
		'_hasStdLog',
		'_status',
		'_state',
		'__links'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generated-IoJenkinsBlueoceanServiceEmbeddedRestJunit'
}

{ #category : #tests }
BlueJUnitTestResult class >> testStatusParser [
	|method fullClass p|
	method := #word asPParser plus flatten.
	fullClass := (#word asPParser plus flatten separatedBy: '.' asPParser) ==> #last.
	p := ((
		((method, (Character value: 8211) asPParser trim, fullClass) ==> [:t | t third -> t first])
		/ 
		'/' asPParser negate star flatten) 
		separatedBy: '/' asPParser trim)
		==> [:t | t reject: [:each | each = '/']].
	^ p optimize
]

{ #category : #accessing }
BlueJUnitTestResult >> fullStageName [
	^ '/ ' join: self testNameParsed allButLast 
]

{ #category : #accessing }
BlueJUnitTestResult >> gtDisplayOn: stream [
	stream nextPutAll: _name
]

{ #category : #accessing }
BlueJUnitTestResult >> gtTestFor: aView [
	<gtView>
	^ self testMethod gtSourceFor: aView
]

{ #category : #accessing }
BlueJUnitTestResult >> isFailed [
	^ self status = 'FAILED'
]

{ #category : #accessing }
BlueJUnitTestResult >> isPassed [
	^ self status = 'PASSED'
]

{ #category : #accessing }
BlueJUnitTestResult >> name [
	^ _name
]

{ #category : #accessing }
BlueJUnitTestResult >> status [
	^ _status
]

{ #category : #accessing }
BlueJUnitTestResult >> statusBackgroundColor [
	^ JenkinsClient backgroundColorForTestStatus: self status
]

{ #category : #accessing }
BlueJUnitTestResult >> testClassName [
	^ self testNameParsed last key
]

{ #category : #accessing }
BlueJUnitTestResult >> testMethod [
	^ self testClassName asClass >> self testMethodName asSymbol 
]

{ #category : #accessing }
BlueJUnitTestResult >> testMethodName [
	^ self testNameParsed last value
]

{ #category : #accessing }
BlueJUnitTestResult >> testNameParsed [
	^ self class testStatusParser parse: self name
]
