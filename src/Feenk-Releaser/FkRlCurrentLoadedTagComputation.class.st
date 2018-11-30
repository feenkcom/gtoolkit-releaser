Class {
	#name : #FkRlCurrentLoadedTagComputation,
	#superclass : #FkRlVersionComputation,
	#category : #'Feenk-Releaser'
}

{ #category : #accessing }
FkRlCurrentLoadedTagComputation >> releaseVersionForRepository: aRepository [
	^ FkRlTagVersion new 
		tagName: aRepository icebergRepository headCommit tags first name
]
