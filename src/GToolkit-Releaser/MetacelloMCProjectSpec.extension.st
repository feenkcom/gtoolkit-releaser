Extension { #name : #MetacelloMCProjectSpec }

{ #category : #'*GToolkit-Releaser' }
MetacelloMCProjectSpec >> projectClass [
    self className == nil
        ifTrue: [ ^ nil ].
    ^ Smalltalk at: self className asSymbol ifAbsent: [  ]
]
