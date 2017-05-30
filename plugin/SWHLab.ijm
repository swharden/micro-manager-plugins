macro "1 captures Action Tool - C037T0d141" {captureAverage(1);}
macro "10 captures Action Tool - C037T0d141T7d140" {captureAverage(10);}
macro "Repeated capture every 1s Action Tool - C037T0d141T7d14s" {captureRepeated(10*1000);}

function handleClick(button) {
	print("Button Bar", "The \""+button+"\" Button was pressed");
}

// scripts here are for capturing stills, averages, video, etc.
// the "capture" stack is expanded with every new capture.

print("LOADED CAPTURE LIBRARY");

function windowExists(exactTitle){
	// returns TRUE is the window exists
	for(i=0;i<nImages();i++){
         selectImage(i+1);
		 if (getTitle()==exactTitle) {return true;}
	}
	return false;
}

function getImageList(bReturnNames){ 
     count = nImages(); 
     if (count == 0) {return -1;}
     setBatchMode(true); 
     currentID = getImageID(); 
     id = newArray(count); 
     if (bReturnNames == true) {names = newArray(count);} 
     for (i=0;i<count;i++){ 
         selectImage(i+1); 
         id[i] = getImageID(); 
         if (bReturnNames == true) {names[i] = getTitle();} 
     } 
     selectImage(currentID); 
     setBatchMode(false); 
     if (bReturnNames == true) {return names;} else {return id;} 
} 

function captureSetup(){
    // run this to prepare for future captures
	if (windowExists("captures")){return;}
    selectWindow("");
    run("Duplicate...", "title=captures");
}

function captureThis(){
    // capture whatever is shown on the live viewer
	captureSetup();
    selectWindow("");
    run("Copy");
    selectWindow("captures");
    run("Add Slice");
    setSlice(nSlices);
    run("Paste");
	setMetadata("Label", d2s(getTime()/1000,3));
}

function captureNext(){
    // capture whatever is shown on the live viewer after it updates
    waitForNextFrame();
	waitForNextFrame();
    captureThis();
}

function waitForNextFrame(){
    // stall until the live viewer is updated
    selectWindow("");
    getRawStatistics(nPixels, lastMean);
    while(1){
        getRawStatistics(nPixels, mean);
        if (mean!=lastMean){
            lastMean=mean; 
            break;
        }
        wait(20);
    }
}

function captureAverage(nSnaps){
	// take 10 frames (or whatever) and average them all
	if (nSnaps<2){captureThis();return;}
    selectWindow("");
    run("Duplicate...", "title=tempAverage");
    for(i=1;i<nSnaps;i++){
        waitForNextFrame();
        run("Copy");
        selectWindow("tempAverage");
        run("Add Slice");
        setSlice(i+1);
        run("Paste");
    }
    selectWindow("tempAverage");
	run("Z Project...", "projection=[Average Intensity]");   
	run("Enhance Contrast", "saturated=0.05"); 
	run("Out [-]");
	run("Out [-]");
	close("tempAverage");
	selectWindow("");
}

function captureRepeated(msBetween){
	// continuously capture video until something crashes.
	nCaptures=0;
	t1=getTime();
	while(windowExists("")){
		nCaptures+=1;
		t2=getTime();
		print("### TIME: "+d2s((t2-t1)/1000,2)+" sec ###");
		print("capturing frame "+nCaptures+" ...");
		exec("numlock ON");
		wait(1000); // to warm up
		captureNext();
		exec("numlock OFF");
		updateDisplay();
		wait(msBetween);
	}
	print("live window closed. terminating video.");
}


function annotateVideo(secPerFrame){
	// given a TIFF stack, annotate its frames.
	// be sure to save it as a BMP image sequence, then load it in AVIDEMUX.
	run("RGB Color");
	getDimensions(width, height, channels, slices, frames);
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
}