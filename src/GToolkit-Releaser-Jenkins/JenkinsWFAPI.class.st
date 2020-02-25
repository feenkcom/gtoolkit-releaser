Class {
	#name : #JenkinsWFAPI,
	#superclass : #JenkinsURL,
	#instVars : [
		'_links',
		'wfJobRun',
		'json'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generator'
}

{ #category : #accessing }
JenkinsWFAPI >> getLinks [
	|links|
	self links ifNotNil: [
	self links keysAndValuesDo: [:key :value |
		
			| codeGenerator theObject varname getResult|
			codeGenerator := JSONCodeGenerator new.
			getResult := self znclient get: (value at:'href').
			varname := key.
			key = 'self' ifTrue: [varname:='_self'].
			[json := NeoJSONReader fromString: getResult.
			json isArray ifTrue: [
				|collection newClassName|
				collection := OrderedCollection new.
				codeGenerator ensureInstVarNamed: varname inClass: self class.
				codeGenerator setWfAttribute: varname toValue: collection inObject: self.
				newClassName := (self className, key allButLast capitalized).
				json do: [:eachJson| 
					theObject := codeGenerator 
						modelFrom:eachJson className:newClassName znclient: self znclient.
					collection add:theObject.]]
			ifFalse: [
				key = 'self' ifTrue: [varname:='_self'.
				codeGenerator modelFrom: json theObject: self znclient: self znclient.
				
				] ifFalse:[
				theObject := codeGenerator 
						modelFrom:json className:(self className,key capitalized)
						znclient: self znclient.
				
				codeGenerator ensureInstVarNamed: varname inClass: self class.
				codeGenerator setWfAttribute: varname toValue: theObject inObject: self.]]
			] 
			on: NeoJSONParseError do: [
				codeGenerator ensureInstVarNamed: varname inClass: self class.
				codeGenerator setWfAttribute: varname toValue: getResult inObject: self.]
		
	]]
]

{ #category : #accessing }
JenkinsWFAPI >> getRawLinks [
	|links|
	links := OrderedCollection new.
	self links ifNotNil: [
	self links keysAndValuesDo: [:key :value |
		
			|json theObject varname getResult|
			
			getResult := self znclient get: (value at:'href').
			links add: (NeoJSONReader fromString: getResult).
			]
	].
	^ links
]

{ #category : #accessing }
JenkinsWFAPI >> links [
	^ _links
]

{ #category : #accessing }
JenkinsWFAPI >> setJSON: jsonDictionary [
	json := jsonDictionary
]

{ #category : #accessing }
JenkinsWFAPI >> setWfJobRun: anObject [
	wfJobRun := anObject
]
