Class {
	#name : #JenkinsWFAPI,
	#superclass : #JenkinsURL,
	#instVars : [
		'_links'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generator'
}

{ #category : #accessing }
JenkinsWFAPI >> getLinks [
	self links keysAndValuesDo: [:key :value |
		
			|json codeGenerator theObject varname|
			codeGenerator := JSONCodeGenerator new.
			json := (NeoJSONReader fromString: (self znclient get: (value at:'href')) ).
			varname := key.
			key = 'self' ifTrue: [varname:='_self'].
			json isArray ifTrue: [
				|collection newClassName|
				collection := OrderedCollection new.
				codeGenerator ensureInstVarNamed: varname inClass: self class.
				codeGenerator setWfAttribute: varname toValue: collection inObject: self.
				newClassName := (self className, key allButLast capitalized).
				json do: [:eachJson| 
					theObject := codeGenerator 
						modelFrom:eachJson className:newClassName znclient: self znclient.
					
					collection add:theObject.
				]
				
			]
			ifFalse: [
				theObject := codeGenerator 
						modelFrom:json className:(self className,key capitalized)
						znclient: self znclient.
				
				codeGenerator ensureInstVarNamed: varname inClass: self class.
				codeGenerator setWfAttribute: varname toValue: theObject inObject: self.
			].
		
	]
]

{ #category : #accessing }
JenkinsWFAPI >> links [
	^ _links
]
