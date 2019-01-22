"load latest version"
EpMonitor current disable.
Metacello new
   baseline: 'GToolkitExamples';
   repository: 'github://feenkcom/gtoolkit-examples/src';
   load.
Metacello new
   baseline: 'GToolkitReleaser';
   repository: 'github://feenkcom/gtoolkit-releaser/src';
   load.
EpMonitor current enable.
Smalltalk snapshot: true andQuit: false.
