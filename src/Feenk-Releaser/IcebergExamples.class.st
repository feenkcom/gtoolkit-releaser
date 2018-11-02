"
!!!This class contains a series of examples that explain iceberg.
Iceberg repositories are held in the IceRepositories class.
[[[
IceRepository registry
]]]


Each repository has branches
[[[
branches := (IceRepository registry detect: [:r | r name = 'feenk-releaser']) allBranches.
branches
]]]


To see the commits of one branch, we created a gtView that shows the ancestors tree of the latest commit in the selected branch
[[[
branches first commit
]]]

"
Class {
	#name : #IcebergExamples,
	#superclass : #Object,
	#category : #'Feenk-Releaser'
}
