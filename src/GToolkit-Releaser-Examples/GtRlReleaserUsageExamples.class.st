"
!GToolkit-Releaser

!!Overview

GT Releaser allows the creation of release versions for applications that use baselines to specify their loading configuration, that is what packages to load, their loading order and their dependencies. GT Releaser works with projects that use deeply nested baselines spread across many git repositories with a mix of baselines with fix dependencies and dependencies to latest versions.

In short, to create a new release a user has to: 
 - ensure that all the code of the application that needs to be releases is loaded in the current image;
 - create a ${class:GtRlReleaseConfiguration}$ configuration controlling various aspects of the release process;
 - run the release exporter to create new versions and baselines that use those versions to load projects. 

The release can be done manually from the image using the inspector as a user interface, or by relying on a command line handler.
This article covers in more details the release process and various ways in which it can be configured. 

"
Class {
	#name : #GtRlReleaserUsageExamples,
	#superclass : #Object,
	#category : #'GToolkit-Releaser-Examples'
}
