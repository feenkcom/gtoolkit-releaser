Class {
	#name : #GtRlClonerSignalsGroup,
	#superclass : #GtRlSignalsGroup,
	#category : #'GToolkit-Releaser-Cloner-Logging'
}

{ #category : #'instance creation' }
GtRlClonerSignalsGroup class >> withAll: aCollection [
	^ self new 
		initializeWith: aCollection
]

{ #category : #ui }
GtRlClonerSignalsGroup >> gtItemsFor: aView [
	<gtView>
	^ aView columnedList
	 	title: 'Events';
	 	priority: 30;
	 	items: [ self items ];
	 	column: 'Timestamp' text: [ :aRecording | aRecording timestamp asString ];
	 	column: 'Type' text: [ :aRecording | aRecording eventName ];
	 	column: 'Baseline' text: [ :aRecording | aRecording baselineName ];
	 	column: 'Repository' text: [ :aRecording | aRecording repositoryUrlString ]
]
