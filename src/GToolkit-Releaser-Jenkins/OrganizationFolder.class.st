Class {
	#name : #OrganizationFolder,
	#superclass : #JenkinsURL,
	#instVars : [
		'_name',
		'_parent'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generated-JenkinsBranch'
}

{ #category : #accessing }
OrganizationFolder >> name [
	^ _name
]

{ #category : #accessing }
OrganizationFolder >> znclient [ 
	^ _parent znclient 
]
