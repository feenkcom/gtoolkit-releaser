Class {
	#name : 'GtRlLoadDirectivesOrderTraversal',
	#superclass : 'Object',
	#category : 'GToolkit-Releaser-Loader'
}

{ #category : 'actions' }
GtRlLoadDirectivesOrderTraversal >> loadOrderFor: aProject [
	| projectsInLoadOrder |
	projectsInLoadOrder := OrderedCollection new.
	self loadOrderFor: aProject in: projectsInLoadOrder.
	^ projectsInLoadOrder
]

{ #category : 'private' }
GtRlLoadDirectivesOrderTraversal >> loadOrderFor: aProject in: currentProjects [
	"I traverse first the children recursively, and only after all the children are traversed, 
	I add the current project to the list if needed. The project is added to the list only if 
	it is not already present. If its present it means it was already traversed as it was also
	a child of another release."
	aProject childProjects do: [ :aChildProject | 
		self loadOrderFor: aChildProject in: currentProjects ].
	(currentProjects includes: aProject) ifFalse: [
		currentProjects add: aProject ].
]
