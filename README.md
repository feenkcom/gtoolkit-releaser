# GT releaser

## How to load

You can load the whole code in Pharo 8.0 using the following snippet:
```
EpMonitor current disable.
Metacello new
   baseline: 'GToolkitReleaser';
   repository: 'github://feenkcom/gtoolkit-releaser/src';
   load.
EpMonitor current enable.
```
