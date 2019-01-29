Extension { #name : #IceWorkingCopy }

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceWorkingCopy >> gtPackagesFor: aView [
	<gtView>
	^ aView columnedList 
		priority: 15;
		title: 'Packages' translated;
		items: [ (IceSortingStrategy new first: #modified) sort: self packages ];
		column: 'Name' item: #gtPackageDescription;
		column: 'Status' item: #gtPackageStatus
]
