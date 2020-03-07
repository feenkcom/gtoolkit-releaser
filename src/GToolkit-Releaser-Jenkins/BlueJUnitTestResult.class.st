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
BlueJUnitTestResult >> statusBackgroundColor [
	^ JenkinsClient backgroundColorForTestStatus: self status
]

{ #category : #accessing }
BlueJUnitTestResult >> testClassName [
	| methodAndClass |
	methodAndClass := self testNameParsed last findTokens: '–'.
	^ (methodAndClass second findTokens: '.') last trimmed
]

{ #category : #accessing }
BlueJUnitTestResult >> testMethod [
	| methodAndClass selector className |
	methodAndClass := self testNameParsed last findTokens: '–'.
	selector := methodAndClass first trimmed.
	className := (methodAndClass second findTokens: '.') last trimmed.
	^ className  asClass >> selector asSymbol
]

{ #category : #accessing }
BlueJUnitTestResult >> testMethodName [
	|methodAndClass |
	methodAndClass := self testNameParsed last findTokens: '–'.
	^ methodAndClass first trimmed.
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
