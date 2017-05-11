run("RGB Color");
getDimensions(width, height, channels, slices, frames);

secPerFrame=1.00;
fontSize=32;

//messageLabels = newArray("1uM glutamate");
//messageFrames = newArray(327);

for (i=0;i<nSlices;i++){

	setSlice(i+1);
	frameTime=IJ.pad(secPerFrame*i/60,3)+":"+IJ.pad(i%60,2)+'.'+IJ.pad(100*((secPerFrame*i)%1),2);
	msg=IJ.pad(i+1,4)+" | "+frameTime;

	// background fill
	//setForegroundColor(139, 0, 47);
	//makeRectangle(0, 0, width, 450);
	//run("Fill", "slice");

	// draw message labels
	/*
	for (j=0;j<messageLabels.length;j++){
		msg=msg+"\n";
		if (messageFrames[j]<=(i+1)){
			msg=msg+messageLabels[j];
		}
	}
	*/

	if (i>=315 && i<=327+60){
		msg=msg+"\n1uM glutamate";
	}

	setFont("Monospaced",fontSize,"bold");
	setForegroundColor(0, 0, 0);
	drawString(msg,12,12+fontSize);

	setForegroundColor(255, 255, 0);
	drawString(msg,10,10+fontSize);
	
}
