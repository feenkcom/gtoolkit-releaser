Class {
	#name : #FkRlNextVersion,
	#superclass : #Object,
	#category : #'Feenk-Releaser'
}

{ #category : #'as yet unclassified' }
FkRlNextVersion class >> findNextVersion [
	"comment stating purpose of message"
	IceRepository registry detect: [ :r | r name = 'GToolkit' ]
]
