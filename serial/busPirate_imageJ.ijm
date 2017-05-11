print("LED on");
exec("C:\\Users\\scott\\Documents\\GitHub\\micro-manager-plugins\\serial\\busPirate_ON.bat");

print("waiting a few seconds..."); 
wait(1000);

print("LED off");
exec("C:\\Users\\scott\\Documents\\GitHub\\micro-manager-plugins\\serial\\busPirate_OFF.bat");