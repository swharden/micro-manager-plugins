# powershell script to turn the bus pirate power lines OFF
$port=new-Object System.IO.Ports.SerialPort COM3,115200,None,8,one
$port.open()
$port.WriteLine("#")
$port.Close()
