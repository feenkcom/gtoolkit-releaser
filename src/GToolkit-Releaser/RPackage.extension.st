Extension { #name : #RPackage }

{ #category : #'*GToolkit-Releaser' }
RPackage >> gtDependencyTreeFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Dependencies';
		priority: 2;
		items: [ (self gtDependencies groupedBy: [ :each | each toPackage ])
				associations sorted: [ :a :b | a key name < b key name ] ];
		"children: [:each | (each gtPackagesUsed asOrderedCollection) copyWithout: each];
		"
		column: 'Package' text: [ :assoc | assoc key name ];
		column: 'Dependencies'
			text: [ :assoc | assoc value size ];
		send: #value
]
