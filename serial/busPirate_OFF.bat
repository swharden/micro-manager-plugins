@echo off

echo "TURNING LED OFF"

powershell "$port=new-Object System.IO.Ports.SerialPort COM123,115200,None,8,one; $port.open(); $port.WriteLine('w'); $port.ReadLine();  $port.Close()"