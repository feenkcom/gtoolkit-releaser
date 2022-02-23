Class {
	#name : #GtRlPostLoadAction,
	#superclass : #GtRlPrePostLoadAction,
	#category : 'GToolkit-Releaser-Loader'
}

{ #category : #accessing }
GtRlPostLoadAction >> actionSelector [
	^ self loadDirective project postLoadAction
]

{ #category : #accessing }
GtRlPostLoadAction >> name [
	^ 'Evaluate post-load action'
]
