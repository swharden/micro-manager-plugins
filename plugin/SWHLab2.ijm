
/////////////////////////////////////////////////////////////////
// ACTION BAR TOOL BUTTONS
/////////////////////////////////////////////////////////////////

macro "Avg 1 Action Tool - C037T0d14aT7d141" {snapAs("unique");}
macro "Avg 9 Action Tool - C037T0d14aT7d149" {captureAverage(9);}
macro "Sum 4 Action Tool - C037T0d14+T7d144" {captureSum(4);}
macro "Sum 9 Action Tool - C037T0d14+T7d149" {captureSum(9);}

macro "snap Green Action Tool - C037T0d14G" {snapGreen();}
macro "snap Red Action Tool -   C037T0d14R" {snapRed();}
macro "merge red and green Action Tool -   C037T0d14M" {snapMerge();}

//macro "Repeated capture every 1s Action Tool - C037T0d141T7d14s" {captureRepeated(5*1000);}

// snapping/merging functions

function snapAs(windowName){
	// copy the current live image into a new frame with the given title
	// if a window with that title already exists, delete it first
	if (windowName=="unique"){
		windowName=d2s(getTime()/1000,3);
	}
	if (windowExists(windowName)){
		selectWindow(windowName);
		close();
	}
	selectWindow("");
    run("Duplicate...", "title="+windowName);
	print("captured "+windowName);
}

function snapGreen(){
	print("snapping green image...");
	snapAs("auto_green");
	selectWindow("auto_green");
	run("Green");
	run("Enhance Contrast", "saturated=0.05");
}

function snapRed(){
	print("snapping red image...");
	snapAs("auto_red");
	selectWindow("auto_red");
	run("Magenta");
	run("Enhance Contrast", "saturated=0.05");
}

function snapMerge(){
	if (!windowExists("auto_red")){print("ERROR: Red channel has not been captured");}
	if (!windowExists("auto_green")){print("ERROR: Green channel has not been captured");}
	if (!windowExists("auto_red")||!windowExists("auto_green")){return;}
	print("merging green and red images...");
	run("Merge Channels...", "c1=auto_red c2=auto_green create ignore");
	setSlice(1);
	run("Magenta");
	rename(d2s(getTime()/1000,3));
	run("Brightness/Contrast...");
}



/////////////////////////////////////////////////////////////////
// IMAGEJ WINDOW MANAGEMENT
/////////////////////////////////////////////////////////////////

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

function windowExists(exactTitle){
	// returns TRUE is the window exists
	for(i=0;i<nImages();i++){
         selectImage(i+1);
		 if (getTitle()==exactTitle) {return true;}
	}
	return false;
}


/////////////////////////////////////////////////////////////////
// FRAME ACQUISITION / IMAGE CAPTURE / IMAGE AVERAGING / VIDEO
/////////////////////////////////////////////////////////////////

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


function captureSum(nSnaps){	
	// take 10 frames (or whatever) and average them all
	print("capturing sum of "+nSnaps+" frames ...");
	
	if (nSnaps<2){captureThis();return;}
    selectWindow("");
    run("Duplicate...", "title=tempSum");
    for(i=1;i<nSnaps;i++){
        waitForNextFrame();
        run("Copy");
        selectWindow("tempSum");
        run("Add Slice");
        setSlice(i+1);
        run("Paste");
    }
    selectWindow("tempSum");
	//run("Z Project...", "projection=[Average Intensity]");   
	run("Z Project...", "projection=[Sum Slices] all");
	run("Enhance Contrast", "saturated=0.02");
	run("Out [-]");
	run("Out [-]");
	close("tempSum");
	//selectWindow("");
	
}

function captureAverage(nSnaps){
	// take 10 frames (or whatever) and average them all
	print("capturing average of "+nSnaps+" frames ...");
	
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
	run("Enhance Contrast", "saturated=0.02"); 
	close("tempAverage");
	//selectWindow("");
}

function captureRepeated(msBetween){
	// continuously capture video until something crashes.
	nCaptures=0;
	while(windowExists("")){
		nCaptures+=1;
		print("capturing frame "+nCaptures+" ...");
		busPirate_ON();
		captureNext();
		busPirate_OFF();
		updateDisplay();
		wait(msBetween);
	}
	print("live window closed. terminating video.");
}


/////////////////////////////////////////////////////////////////
// ANNOTATIONS / DRAWING TEXT ON TOP OF IMAGES AND VIDEO
/////////////////////////////////////////////////////////////////

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

/////////////////////////////////////////////////////////////////
// HARDWARE CONTROL
/////////////////////////////////////////////////////////////////

function busPirate_ON() {
	print("turning LED on...");
	exec("powershell -inputformat none -command $port=new-Object System.IO.Ports.SerialPort COM123,115200,None,8,one; $port.open(); $port.WriteLine('#'); $port.ReadLine(); $port.WriteLine('m'); $port.ReadLine(); $port.WriteLine('2'); $port.WriteLine('W'); $port.ReadLine(); $port.Close();");
	print("LED IS ON!");
}

function busPirate_OFF() {
	print("turning LED off...");
	exec("powershell -inputformat none -command $port=new-Object System.IO.Ports.SerialPort COM123,115200,None,8,one; $port.open(); $port.WriteLine('#'); $port.ReadLine(); $port.Close();");
	print("LED IS OFF!");
}
