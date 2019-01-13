Class {
	#name : #OrganizationFolder,
	#superclass : #JenkinsURL,
	#instVars : [
		'name',
		'_parent'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generated-JenkinsBranch'
}

{ #category : #accessing }
OrganizationFolder >> name [
	^ name
]

{ #category : #accessing }
OrganizationFolder >> znclient [ 
	^ _parent znclient 
]
