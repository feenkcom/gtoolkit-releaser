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
	^ self testMethod gtSourceFor: aView
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
	|classAndSelector theExampleClass methodAndClass method class|
	methodAndClass := self testNameParsed last findTokens: '–'.
	method := methodAndClass first trimmed.
	class := (methodAndClass second findTokens: '.') last trimmed.
	theExampleClass := class asClass.
	^ theExampleClass methods detect: [:m | m name = (class, '>>#', method)]
]

{ #category : #accessing }
BlueJUnitTestResult >> testMethodName [
	|methodAndClass method class|
	methodAndClass := self testNameParsed last findTokens: '–'.
	method := methodAndClass first trimmed.
	class := (methodAndClass second findTokens: '.') last trimmed.
	^ class, '>>#', method

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
