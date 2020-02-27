Class {
	#name : #JenkinsWFAPI,
	#superclass : #JenkinsURL,
	#instVars : [
		'_links',
		'wfJobRun',
		'json',
		'id',
		'parentIds',
		'parentWfNodes'
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
			codeGenerator setCurrentWfJobRun: wfJobRun.
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
JenkinsWFAPI >> getParentNodes [
	|parentJson theObject codeGenerator fromCache resultList|
	theObject := nil.
	self getLinks.
	resultList := OrderedCollection new.
	self parentIds isNotNil ifTrue: [
		wfJobRun ifNotNil: [
			codeGenerator := JSONCodeGenerator new.
			codeGenerator setCurrentWfJobRun: self wfJobRun.
			self parentIds do: [:pid |
			  fromCache := (wfJobRun nodeWithId:pid).
			  fromCache ifNotNil: [resultList add: fromCache ].
			  fromCache ifNil: [
			  	  parentJson := self parentJSON:pid.
					theObject := codeGenerator 
						modelFrom:parentJson className:'WfJobRunNode'
						znclient: self znclient.
					theObject setWfJobRun: self wfJobRun.
					resultList add: theObject ]].
					codeGenerator ensureInstVarNamed: 'parentNodes' inClass: self class.
					codeGenerator setWfAttribute: 'parentNodes' toValue: resultList inObject: self]].
	parentWfNodes := resultList.
	^ resultList
	
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
JenkinsWFAPI >> gtParentNodes: aView [
	|nodes |
	<gtView>
	self wfJobRun isNotNil ifTrue: [
	nodes := self parentNodes .
	nodes isNotNil ifTrue: [
		^ aView columnedList
			title: 'ParentNode' translated;
			priority: 10;
			items: [ nodes];
			column: 'ID' translated do: [ :aColumn | 
				aColumn 
					item: [ :item| item id ];
					matchParent ]
					]].
	^ aView empty
]

{ #category : #accessing }
JenkinsWFAPI >> id [
	^ id
]

{ #category : #accessing }
JenkinsWFAPI >> links [
	^ _links
]

{ #category : #accessing }
JenkinsWFAPI >> parentIds [
	^ parentIds
]

{ #category : #accessing }
JenkinsWFAPI >> parentJSON: parentId [
	^ NeoJSONReader fromString: (znclient get: (self parentURL: parentId))
]

{ #category : #accessing }
JenkinsWFAPI >> parentNodes [
	parentWfNodes ifNil: [parentWfNodes := self getParentNodes].
	^ parentWfNodes
]

{ #category : #accessing }
JenkinsWFAPI >> parentURL: parentId [
	|p selfLink re|
	p := parentId.
	re := ('node/',(id asString)) asRegex.
	selfLink:=self links at:#self at:#href.
	^ re copy: selfLink replacingMatchesWith: ('node/',p)
]

{ #category : #accessing }
JenkinsWFAPI >> setJSON: jsonDictionary [
	json := jsonDictionary
]

{ #category : #accessing }
JenkinsWFAPI >> setWfJobRun: anObject [
	wfJobRun := anObject.
	wfJobRun registerNode: self.
]

{ #category : #accessing }
JenkinsWFAPI >> wfJobRun [
	^ wfJobRun
]
