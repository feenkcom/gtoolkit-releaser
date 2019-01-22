"load latest version"
EpMonitor current disable.
Metacello new
   baseline: 'GToolkitReleaser';
   repository: 'github://feenkcom/gtoolkit-releaser/src';
   load.
EpMonitor current enable.
Smalltalk snapshot: true andQuit: false.
