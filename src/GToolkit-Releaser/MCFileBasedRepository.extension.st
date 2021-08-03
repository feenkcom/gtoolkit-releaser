Extension { #name : 'MCFileBasedRepository' }

{ #category : '*GToolkit-Releaser' }
MCFileBasedRepository >> basicStoreVersion: aVersion [
	self
		writeStreamForFileNamed: aVersion fileName
		do: [:s | [aVersion fileOutOn: s] on: TonelParseError do: [Error  signal: ('TonelParseError while parsing file ',aVersion fileName) ]].
	aVersion isCacheable ifTrue: [
		cache ifNil: [cache := Dictionary new].
		cache at: aVersion fileName put: aVersion].

]
