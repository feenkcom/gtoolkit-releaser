Class {
	#name : #MetacelloMethodSectionPath,
	#superclass : #Array,
	#type : #variable,
	#category : #'GToolkit-Releaser-BaselineModel-Metacello'
}

{ #category : #converting }
MetacelloMethodSectionPath >> asAttributeOrPath [
    self size = 1
        ifTrue: [ 
            | attribute |
            attribute := self at: 1.
            ^ attribute size = 1
                ifTrue: [ attribute at: 1 ]
                ifFalse: [ attribute ] ].
    ^ self
]

{ #category : #converting }
MetacelloMethodSectionPath >> asMetacelloAttributePath [
    ^ self
]
