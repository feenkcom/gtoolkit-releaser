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

{ #category : #accessing }
BlueJUnitTestResult >> gtDisplayOn: stream [
	stream nextPutAll: _name
]

{ #category : #accessing }
BlueJUnitTestResult >> gtTestFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Test';
		text: [self testMethod]
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
BlueJUnitTestResult >> testMethod [
	^ _errorStackTrace lines last
]

{ #category : #accessing }
BlueJUnitTestResult >> testNameParsed [
	|method fullClass p|
	method := #word asPParser plus flatten.
	fullClass := #word asPParser plus flatten separatedBy: '.' asPParser.
	p := ((
		(method, ' - ' asPParser, fullClass)
		/ 
		'/' asPParser negate star flatten) 
		separatedBy: '/' asPParser trim).
	^ p parse: self name
]
