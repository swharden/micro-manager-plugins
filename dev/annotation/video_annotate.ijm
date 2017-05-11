run("RGB Color");
getDimensions(width, height, channels, slices, frames);

secPerFrame=1.00;
fontSize=32;

for (i=0;i<nSlices;i++){

	// prepare frame number and time code
	setSlice(i+1);
	frameTime=IJ.pad(secPerFrame*i/60,3)+":"+IJ.pad(i%60,2)+'.'+IJ.pad(100*((secPerFrame*i)%1),2);
	msg=IJ.pad(i+1,4)+" | "+frameTime;

	// add custom messages for certain frame ranges
	if (i>=315 && i<=327+60){msg=msg+"\n1uM glutamate";}

	// draw black background shadow
	setFont("Monospaced",fontSize,"bold");
	setForegroundColor(0, 0, 0);
	drawString(msg,12,12+fontSize);
	
	// draw yellow foreground
	setForegroundColor(255, 255, 0);
	drawString(msg,10,10+fontSize);
	
}
