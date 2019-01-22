"load latest version"
EpMonitor current disable.
Metacello new
   githubUser: 'feenkcom' project: 'DeepTraverser' commitish: 'master' path: 'src';
   baseline: 'DeepTraverser';
   load.
Metacello new
  repository: 'github://svenvc/NeoJSON/repository';
  baseline: 'NeoJSON';
  load.
Metacello new
   baseline: 'Beacon';
   repository: 'github://pharo-project/pharo-beacon/repository';
   load.
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
