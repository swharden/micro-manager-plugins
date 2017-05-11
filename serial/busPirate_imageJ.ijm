scriptPath="C:\\Users\\swharden\\Documents\\GitHub\\micro-manager-plugins\\macros\\serial";

print("LED on");
exec(scriptPath+"/busPirate_ON.bat");

print("waiting a few seconds..."); 
wait(1000);

print("LED off");
exec(scriptPath+"/busPirate_OFF.bat");
