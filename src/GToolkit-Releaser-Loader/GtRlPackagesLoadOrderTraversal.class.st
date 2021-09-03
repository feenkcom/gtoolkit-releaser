Class {
	#name : 'GtRlPackagesLoadOrderTraversal',
	#superclass : 'Object',
	#category : 'GToolkit-Releaser-Loader'
}

{ #category : 'private' }
GtRlPackagesLoadOrderTraversal >> loadOrderFor: aPackage in: currentPackages [
	"I traverse first the required packages recursively, and only after all the requirements are traversed, 
	I add the current package to the list if needed. The package is added to the list only if 
	it is not already present. If its present it means it was already traversed as it was also
	a requiremenet of another package."
	aPackage requiredPackages do: [ :aRequiredPackage | 
		self loadOrderFor: aRequiredPackage in: currentPackages ].
	(currentPackages includes: aPackage) ifFalse: [
		currentPackages add: aPackage ].
]

{ #category : 'actions' }
GtRlPackagesLoadOrderTraversal >> packagesLoadOrderFor: aProject [
	| packagesInLoadOrder |
	packagesInLoadOrder := OrderedCollection new.
	aProject rootPackages do: [ :aPackage | 
		self loadOrderFor: aPackage in: packagesInLoadOrder ].
	^ packagesInLoadOrder
]
