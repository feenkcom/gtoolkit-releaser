Class {
	#name : #GtRlLoaderSignalsGroup,
	#superclass : #GtRlSignalsGroup,
	#category : #'GToolkit-Releaser-Loader-Logging'
}

{ #category : #ui }
GtRlLoaderSignalsGroup >> gtItemsFor: aView [
	<gtView>
	^ aView columnedList
	 	title: 'Signals';
	 	priority: 30;
	 	items: [ self items ];
	 	column: 'Timestamp' text: [ :aSignal | aSignal timestamp asString ];
	 	column: 'Type' text: [ :aSignal | aSignal eventName ];
	 	column: 'Baseline' text: [ :aSignal | aSignal baselineName ];
	 	column: 'Action Type' text: [ :aSignal | aSignal actionType ];
	 	column: 'Action Description' text: [ :aSignal | aSignal actionDescription ]
]
