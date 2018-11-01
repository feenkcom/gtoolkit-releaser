Extension { #name : #IceLibgitRepository }

{ #category : #'*Feenk-Releaser' }
IceLibgitRepository >> gtBranchesFor: aView [
<gtView>
	^ (self allBranches gtItemsFor: aView) 
		title: 'Branches';
		priority: 30
]
