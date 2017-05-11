// scripts here are for capturing stills, averages, video, etc.
// the "capture" stack is expanded with every new capture.

function captureSetup(){
    // run this to prepare for future captures
    selectWindow("");
    run("Duplicate...", "title=captures");
}

function captureThis(){
    // capture whatever is shown on the live viewer
    selectWindow("");
    run("Copy");
    selectWindow("tempAverage");
    run("Add Slice");
    setSlice(i+1);
    run("Paste");
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

function captureAverage(nSnaps){
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
}

macro "Average 10 Frames Action Tool - C037T0d141T7d140" {
    captureAverage(10);
}

macro "Average 50 Frames Action Tool - C037T0d145T7d140" {
    captureAverage(50);
}

