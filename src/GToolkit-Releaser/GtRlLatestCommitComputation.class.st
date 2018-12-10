Class {
	#name : #GtRlLatestCommitComputation,
	#superclass : #GtRlVersionComputation,
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlLatestCommitComputation >> releaseVersionForRepository: aRepository [
	^ GtRlCommitIdVersionNumber new
		commitId: aRepository icebergRepository headCommit id
]
