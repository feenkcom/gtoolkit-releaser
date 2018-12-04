Class {
	#name : #GtRlLatestCommitComputation,
	#superclass : #GtRlVersionComputation,
	#category : #'Feenk-Releaser'
}

{ #category : #accessing }
GtRlLatestCommitComputation >> releaseVersionForRepository: aRepository [
	^ GtRlCommitVersion new
		commitId: aRepository icebergRepository headCommit id
]
