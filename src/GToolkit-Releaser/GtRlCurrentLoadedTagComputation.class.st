Class {
	#name : #GtRlCurrentLoadedTagComputation,
	#superclass : #GtRlVersionComputation,
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlCurrentLoadedTagComputation >> releaseVersionForRepository: aRepository [
	^ GtRlTagVersion new 
		tagName: aRepository icebergRepository headCommit tags first name
]
