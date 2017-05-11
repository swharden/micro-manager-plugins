@echo off

echo "TURNING LED ON"
busPirate_ON.bat

echo "WAITING A FEW SECONDS..."
sleep 2

echo "TURNING LED OFF"
busPirate_OFF.bat
echo "DONE"