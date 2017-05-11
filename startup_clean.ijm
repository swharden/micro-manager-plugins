run(swhlabPluginPath+"macros\\capture\\live.ijm");
   
macro "Average 10 Frames Action Tool - C037T0d141T7d140" {
	print(getInfo("macro.filepath"));
    run("captureAverage [10]")
	//captureAverage(10);
}

macro "Average 50 Frames Action Tool - C037T0d145T7d140" {
    captureAverage(50);
}