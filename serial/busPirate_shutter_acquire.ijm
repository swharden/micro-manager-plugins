macroPath="C:/Users/swharden/Documents/GitHub/micro-manager-plugins/macros/";

print("LED on");
exec(macroPath+"serial/busPirate_ON.bat");

print("waiting a few seconds..."); 
wait(1000);

print("LED off");
exec(macroPath+"serial//busPirate_OFF.bat");
