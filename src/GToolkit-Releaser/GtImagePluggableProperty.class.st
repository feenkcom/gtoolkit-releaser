Class {
	#name : #GtImagePluggableProperty,
	#superclass : #GtImageProperty,
	#instVars : [
		'name',
		'description',
		'value',
		'key'
	],
	#category : #'GToolkit-Releaser-GToolkit-Releaser'
}

{ #category : #accessing }
GtImagePluggableProperty >> description [

	^ description ifNil: [ self value ]
]

{ #category : #accessing }
GtImagePluggableProperty >> description: anObject [

	description := anObject
]

{ #category : #accessing }
GtImagePluggableProperty >> key [

	^ key ifNil: [ self name ]
]

{ #category : #accessing }
GtImagePluggableProperty >> key: anObject [

	key := anObject
]

{ #category : #accessing }
GtImagePluggableProperty >> name [

	^ name
]

{ #category : #accessing }
GtImagePluggableProperty >> name: anObject [

	name := anObject
]

{ #category : #accessing }
GtImagePluggableProperty >> value [

	^ value
]

{ #category : #accessing }
GtImagePluggableProperty >> value: anObject [

	value := anObject
]
