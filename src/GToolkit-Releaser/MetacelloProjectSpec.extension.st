Extension { #name : #MetacelloProjectSpec }

{ #category : #'*GToolkit-Releaser' }
MetacelloProjectSpec >> projectClass [
	<gtPharoPatch: #Pharo>
	
    self className == nil
        ifTrue: [ ^ nil ].
    ^ Smalltalk at: self className asSymbol ifAbsent: [  ]
]
