Class {
	#name : #FkRlLatestCommitComputation,
	#superclass : #FkRlVersionComputation,
	#category : #'Feenk-Releaser'
}

{ #category : #accessing }
FkRlLatestCommitComputation >> releaseVersionForRepository: aRepository [
	^ FkRlCommitVersion new
		commitId: aRepository icebergRepository headCommit id
]
