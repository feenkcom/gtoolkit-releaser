Class {
	#name : 'GtRlPreLoadAction',
	#superclass : 'GtRlPrePostLoadAction',
	#category : 'GToolkit-Releaser-Loader'
}

{ #category : 'accessing' }
GtRlPreLoadAction >> actionSelector [
	^ self loadDirective project preLoadAction
]

{ #category : 'accessing' }
GtRlPreLoadAction >> name [
	^ 'Evaluate pre-load actions'
]
