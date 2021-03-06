// scripts here are for capturing stills, averages, video, etc.
// the "capture" stack is expanded with every new capture.

print("LOADED CAPTURE LIBRARY");

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

macro "captureNext"{
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
