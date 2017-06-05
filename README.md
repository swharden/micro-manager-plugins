# micro-manager-plugins
µ-Manager (ImageJ) plugins for image/video acquisition in an electrophysiology environment

## Setup
* Use the GitHub desktop client (or just extract the zip) so the micro-manager-plugins folder is somewhere on your local computer. Then, edit your `StartupMacros.txt` file (which lives in Program Files / Micro Manager / macros) and add a line so `startup.ijm` is executed.
```
macro "AutoRun" {
  run("Micro-Manager Studio");
  run("Install...", "install=[C:\\Program Files\\Micro-Manager-1.4\\macros\\micro-manager-plugins\\plugin\\SWHLab.ijm]");
  
}
```

## Links
* https://micro-manager.org/
* [ImageJ macro language](https://imagej.nih.gov/ij/developer/macro/macros.html)
* [ImageJ built-in functions](https://imagej.nih.gov/ij/developer/macro/functions.html)

## Demo: timestamping (and drug-stamping) TIFs
I saved micrographs as a TIF then converted them to a BMP image sequence and used AVIDemux to make it an MP4 suitable for YouTube
* https://www.youtube.com/watch?v=1OHvPi1TbII
