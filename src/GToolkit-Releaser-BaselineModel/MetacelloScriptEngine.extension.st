Extension { #name : #MetacelloScriptEngine }

{ #category : #'*GToolkit-Releaser-BaselineModel' }
MetacelloScriptEngine class >> baseNameOf: className [
	<gtPharoPatch: #Pharo14>
  ^ (className beginsWith: 'BaselineOf')
    ifTrue: [ className copyFrom: 'BaselineOf' size + 1 to: className size ]
    ifFalse: [ 
      (className beginsWith: 'ConfigurationOf')
        ifTrue: [ className copyFrom: 'ConfigurationOf' size + 1 to: className size ]
        ifFalse: [ className ] ]
]
