Extension { #name : #IceMerge }

{ #category : #'*GToolkit-Releaser' }
IceMerge >> executeWithAcceptingLeftOnConflict [
	"at begining of this, there is a possibility that imageCommit needs to be 'fixed' to use."
	| commitToAdvance |
	mergeCommit validateCanMerge.
	self isAlreadyMerged ifTrue: [ ^ self ].
	
	" 1 - Merge changes.
	If the image and merge commit are the same, and the headCommit is their ancestor, we should do nothing.
	Otherwise, we should merge the two commits we have, discerning well which is the left and which is the right commit." 
	self calculateChanges.
	self hasConflicts ifTrue: [ 
		self conflictsDo: [ :operation |
			operation selectLeft ] ].
	commitToAdvance := self updateHead.
	
	self updateWorkingCopy.
	
	^ commitToAdvance
]

{ #category : #'*GToolkit-Releaser' }
IceMerge >> executeWithAcceptingLeftOnConflictAndWithoutImageUpdate [
	"at begining of this, there is a possibility that imageCommit needs to be 'fixed' to use."
	| commitToAdvance |
	
	[ mergeCommit validateCanMerge ] 
		on: Warning 
		do: [ :warning |
			(warning messageText beginsWith: 'Experimental Feature: merge when there is a dirty working copy')
				ifFalse: [ warning signal ] ].
	
	self isAlreadyMerged ifTrue: [ ^ self ].
	
	" 1 - Merge changes.
	If the image and merge commit are the same, and the headCommit is their ancestor, we should do nothing.
	Otherwise, we should merge the two commits we have, discerning well which is the left and which is the right commit." 
	self calculateChanges.
	self hasConflicts ifTrue: [ 
		self conflictsDo: [ :operation |
			operation selectLeft ] ].
	commitToAdvance := self updateHead.
	
	"Do not update the working copy"
	"repository workingCopy loadChangesInWorkingCopy: self changesToWorkingCopyTree."
	repository workingCopy refreshDirtyPackages.
	
	^ commitToAdvance
]
