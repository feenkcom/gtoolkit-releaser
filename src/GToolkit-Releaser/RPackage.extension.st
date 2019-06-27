Extension { #name : #RPackage }

{ #category : #'*GToolkit-Releaser' }
RPackage >> gtDependencyTreeFor: aView [
	<gtView>
	^ aView columnedTree
		title: 'Dependency Tree';
		priority: 2;
		items: [(self usedPackages asOrderedCollection) copyWithout: self];
		children: [:each | (each usedPackages asOrderedCollection) copyWithout: each];
		column: 'Name' do: [:column | column item: [:pack | pack name]; matchParent]
]
