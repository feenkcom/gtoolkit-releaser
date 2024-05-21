Extension { #name : #MetacelloMCProjectSpec }

{ #category : #'*GToolkit-Releaser' }
MetacelloMCProjectSpec >> projectClass [
	<gtPharoPatch: #Pharo>
	
    self className == nil
        ifTrue: [ ^ nil ].
    ^ Smalltalk at: self className asSymbol ifAbsent: [  ]
]
