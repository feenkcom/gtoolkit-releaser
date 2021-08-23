Extension { #name : 'IceCommit' }

{ #category : '*GToolkit-Releaser-Cloner' }
IceCommit >> gtClonerVersionDescription [
	
	self tags
		ifNotEmpty: [ :tags |
			^ ', ' join: (tags collect: [ :each | each name ]) ].
		
	^ self id
]
