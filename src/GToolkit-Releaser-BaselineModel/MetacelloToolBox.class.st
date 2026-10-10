"
MetacelloToolbox implements a toolbox API for Metacello.

The toolbox methods on the class-side implement scripts for a number of commonly performed Metacello development tasks. The methods should be used in development scripts or GUI tools so that a common implementation is preserved across the toolset.
"
Class {
	#name : #MetacelloToolBox,
	#superclass : #Object,
	#instVars : [
		'project',
		'methodSpec'
	],
	#category : #'GToolkit-Releaser-BaselineModel-Metacello'
}

{ #category : #utilities }
MetacelloToolBox class >> baseNameOf: configurationClassName [
  "Return the baseName for the given configuration class name."

  <apiDocumentation>
  ^ (configurationClassName beginsWith: 'ConfigurationOf')
    ifTrue: [ 
      configurationClassName
        copyFrom: 'ConfigurationOf' size + 1
        to: configurationClassName size ]
    ifFalse: [ configurationClassName ]
]

{ #category : #utilities }
MetacelloToolBox class >> baselineNameFrom: baseName [
  "Return the fully-qualified baseline class name."

  <apiDocumentation>
  ^ MetacelloScriptEngine baselineNameFrom: baseName
]

{ #category : #'instance creation' }
MetacelloToolBox class >> baselineNamed: baseName [
  ^ self new
    baselineNamed: baseName;
    yourself
]

{ #category : #utilities }
MetacelloToolBox class >> configurationNameFrom: baseName [
    "Return the fully-qualified configuration class name."

    <apiDocumentation>
    ^ MetacelloScriptEngine configurationNameFrom: baseName
]

{ #category : #utilities }
MetacelloToolBox class >> platformAttributes [
	"Answer the list of platform attributes for the current platform"
	<apiDocumentation>
	^MetacelloPlatform current defaultPlatformAttributes
]

{ #category : #'api-configuration' }
MetacelloToolBox >> addBaselineOfSection: sectionAttributeOrPath requiredProjects: projectList packages: packageList dependencies: dependecies includes: includes files: files repositories: repositories preLoadDoIts: preLoadDoIts postLoadDoIts: postLoadDoIts supplyingAnswers: supplyingAnswers groups: groups versionSpecsDo: aBlock [
  "
		projectList - collection of project base names (without ConfigurationOf prefix)
		packageList - collection of package base names
		dependencies - collection of associations where key is name of package and value is collection of required packages and projects
		includes - collection of associations where key is name of package and value is collection of included packages and projects
		files - collection of associations where key is name of package and value is name of file
		repositories - collection of associations where key is name of package and value is collection of repository descriptions
		preLoadDoIts - collection of associations where key is name of package and value is preload doit selector
		postLoadDoIts - collection of associations where key is name of package and value is postload doit selector
		supplyingAnswers - collection of associations where key is name of package and value is the supplyingAnswers array
		groups - collection of associations where key is the name of the group and value is the collection of group members
	"

  | versionSpec dependencyMap includesMap filesMap repositoriesMap preLoadDoItsMap postLoadDoItsMap supplyingAnswersMap |
  versionSpec := self createVersionSpec: self methodSpec versionString.
  dependencyMap := self buildMapFrom: dependecies for: packageList.
  includesMap := self buildMapFrom: includes for: packageList.
  filesMap := self buildMapFrom: files for: packageList.
  repositoriesMap := self
    buildMapFrom: repositories
    for: packageList , projectList.
  preLoadDoItsMap := self buildMapFrom: preLoadDoIts for: packageList.
  postLoadDoItsMap := self buildMapFrom: postLoadDoIts for: packageList.
  supplyingAnswersMap := self buildMapFrom: supplyingAnswers for: packageList.
  projectList
    do: [ :projectName | 
      | spec |
      spec := self createProjectReferenceSpec: projectName.
      repositoriesMap
        at: projectName
        ifPresent: [ :repositoriesList | repositoriesList do: [ :repoString | spec repository: repoString ] ].
      versionSpec packages merge: spec ].
  packageList
    do: [ :packageName | 
      | spec |
      spec := self createPackageSpec: packageName.
      dependencyMap
        at: packageName
        ifPresent: [ :dependencyList | spec requires: dependencyList ].
      includesMap
        at: packageName
        ifPresent: [ :includesList | spec includes: includesList ].
      filesMap at: packageName ifPresent: [ :file | spec file: file ].
      repositoriesMap
        at: packageName
        ifPresent: [ :repositoriesList | repositoriesList do: [ :repoString | spec repository: repoString ] ].
      preLoadDoItsMap
        at: packageName
        ifPresent: [ :preLoad | spec preLoadDoIt: preLoad ].
      postLoadDoItsMap
        at: packageName
        ifPresent: [ :postLoad | spec postLoadDoIt: postLoad ].
      supplyingAnswersMap
        at: packageName
        ifPresent: [ :answer | spec answers: answer ].
      versionSpec packages merge: spec ].
  groups
    do: [ :assoc | 
      | spec |
      spec := self createGroupSpec: assoc key.
      spec includes: assoc value.
      versionSpec packages merge: spec ].
  aBlock value: versionSpec.
  self methodSpec
    addMethodSection: ((sectionAttributeOrPath class = MetacelloMethodSectionPath)  
    	ifTrue: [sectionAttributeOrPath]
    	ifFalse: [
    		sectionAttributeOrPath isSymbol 
    			ifTrue: [MetacelloMethodSectionPath withAll: {sectionAttributeOrPath}]
    			ifFalse: [MetacelloMethodSectionPath withAll: sectionAttributeOrPath]])
 
    versionSpec: versionSpec
]

{ #category : #private }
MetacelloToolBox >> baselineNameFrom: baseName [
  ^ self class baselineNameFrom: baseName
]

{ #category : #'api-configuration' }
MetacelloToolBox >> baselineNamed: baseName [
  | baselineName |
  "Check if the class does not exist"
  baselineName := self baselineNameFrom: baseName.
  (Smalltalk includesKey: baselineName asSymbol)
    ifFalse: [ 
      "Create the configuration class"
      self ensureMetacello.

		self class classInstaller make: [ :aBuilder | 
			aBuilder 
				name: baselineName asSymbol;
				superclass: BaselineOf;
				package: baselineName].

     self class packageOrganizer ensurePackage: baselineName.
     
      (Smalltalk at: baselineName asSymbol)
        compile: 'baseline: spec <baseline>'
        classified: 'baseline'	"a bit of a hack here to create an initial null basline method" ].
  project := (Smalltalk at: baselineName asSymbol)
    project
]

{ #category : #private }
MetacelloToolBox >> buildMapFrom: mapList for: packageList [
	| map |
	map := Dictionary new.
	mapList
		do: [ :assoc | 
			| pkgName |
			pkgName := assoc key.
			(packageList includes: pkgName)
				ifFalse: [ self error: 'package ' , pkgName printString , ' not found in packages.' ].
			map at: pkgName put: assoc value ].
	^ map
]

{ #category : #'spec creation' }
MetacelloToolBox >> classicCreateProjectReferenceSpec: projectBaseName [
  | configurationName projectReferenceProject versionString |
  configurationName := self configurationNameFrom: projectBaseName.
  projectReferenceProject := (MetacelloPlatform current
    globalNamed: configurationName asSymbol
    ifAbsent: [ 
      self
        error:
          'The project with configuration ' , configurationName printString
            , ' for the project ' , projectBaseName printString
            , ' is not currently loaded into the image.' ])
    project.
  versionString := (projectReferenceProject hasVersion: #'stable')
    ifTrue: [ #'stable' ]
    ifFalse: [ #'bleedingEdge' ].
  ^ project projectReferenceSpec
    name: projectBaseName;
    projectReference:
        (project projectSpec
            name: projectBaseName;
            className: configurationName;
            versionString: versionString;
            yourself);
    yourself
]

{ #category : #'api-configuration' }
MetacelloToolBox >> commitBaselineOfMethod [
  self methodSpec ifNil: [ ^ self ].
  self methodSpec compileMethod.
  project := project configuration class project.	"recalculate project"
  project version: self methodSpec versionString.
  
  methodSpec := nil
]

{ #category : #private }
MetacelloToolBox >> configurationNameFrom: baseName [	
	^self class configurationNameFrom: baseName
]

{ #category : #accessing }
MetacelloToolBox >> constructor [

	| constructor |
	constructor := MetacelloToolBoxConstructor new.
	constructor configuration: project configuration class new.
	^constructor
]

{ #category : #'api-configuration' }
MetacelloToolBox >> createBaselineOfMethod: selector inCategory: category [
  methodSpec := MetacelloBaselineOfMethodSpec new
    project: project;
    selector: selector;
    category: category;
    yourself
]

{ #category : #'spec creation' }
MetacelloToolBox >> createGroupSpec: baseName [
	^ (self project groupSpec)
		name: baseName;
		yourself
]

{ #category : #'spec creation' }
MetacelloToolBox >> createPackageSpec: baseName [
	^ (project packageSpec)
		name: baseName;
		yourself
]

{ #category : #'spec creation' }
MetacelloToolBox >> createProjectReferenceSpec: projectBaseName [
  | projectSpec |
  projectSpec := (Metacello image
    project: projectBaseName;
    list)
    detect: [ :each | true ]
    ifNone: [ ^ self classicCreateProjectReferenceSpec: projectBaseName ].
  ^ project projectReferenceSpec
    name: projectBaseName;
    projectReference: projectSpec;
    yourself
]

{ #category : #'spec creation' }
MetacelloToolBox >> createVersionSpec: versionString [
	| versionSpec |
	versionSpec := project versionSpec.
	versionSpec versionString: versionString.
	^ versionSpec
]

{ #category : #private }
MetacelloToolBox >> ensureMetacello [
	"noop for now"
]

{ #category : #'api-configuration' }
MetacelloToolBox >> imports: importList [

	self methodSpec imports: importList
]

{ #category : #accessing }
MetacelloToolBox >> methodSpec [

	^methodSpec
]

{ #category : #accessing }
MetacelloToolBox >> project [

	^project
]

{ #category : #accessing }
MetacelloToolBox >> project: aMetacelloProject [

	project := aMetacelloProject
]
