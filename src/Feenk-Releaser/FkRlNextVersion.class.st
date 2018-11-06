Class {
	#name : #FkRlNextVersion,
	#superclass : #Object,
	#category : #'Feenk-Releaser'
}

{ #category : #'as yet unclassified' }
FkRlNextVersion class >> findNextVersion [
	"comment stating purpose of message"
	| repository allTags semanticVersionTags |
	repository := IceRepository registry detect: [ :r | r name = 'feenk-releaser' ].
	allTags := ((repository branchNamed: 'master') commit withDeepCollect: #ancestors) flatCollect: #tags. 
	semanticVersionTags := allTags select: [ :t | t name matchesRegex: '[0-9]+\.[0-9]+\.[0-9]+' ].
	^ semanticVersionTags collect:  [ :each | 
		|tokens| 
		tokens := each name findTokens: '.'. 
		FkRlSemanticVersion new major: tokens first; minor: tokens second; patch: tokens third] last incrementPatch.
	



]
