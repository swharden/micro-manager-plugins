macro "captureSetup"{
    // run this to prepare for future captures
    selectWindow("");
    run("Duplicate...", "title=captures");
}

macro "captureAverage"{
	if (getArgument()==""){
		print("REQUIRES ARGUMENT (nSnaps)");
		return;
	} else {
		nSnaps=getArgument();
		print("capturing average of "+nSnaps+" snaps");
		//runMacro("micro-manager-plugins/capture/captureNext.ijm");
	}
}