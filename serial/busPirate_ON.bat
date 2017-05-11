@echo off

echo "TURNING LED ON"

powershell "$port=new-Object System.IO.Ports.SerialPort COM3,115200,None,8,one; $port.open(); $port.WriteLine('#'); $port.ReadLine(); $port.WriteLine('m'); $port.ReadLine(); $port.WriteLine('2'); $port.ReadLine(); $port.WriteLine('3'); $port.ReadLine(); $port.WriteLine('W'); $port.ReadLine(); $port.Close()"