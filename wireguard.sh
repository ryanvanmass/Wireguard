#!/bin/bash
############### Device Selection ###############
echo "Select one of the following:"
echo "1. Server"
echo "2. Client"
echo "3. Add Device (PC)"
echo "4. Add Device (Mobile)"
read Device

############### Configures baste on User Input ###############
if [ $Device = 1 ]
then
    sh ./Server/setup.sh
elif [ $Device = 2 ]
then
    sh ./Client/setup.sh
elif [ $Device = 3 ]
then
    sh ./Server/addpeer.sh
elif [ $Device = 4 ]
then
    sh ./Server/mobileclient.sh
else
    echo "Error Invalid Input"
fi

############### Restarts Server ###############
echo "It is recommended that you restart the Server. Would you like to do this now? (1 for yes or 2 for no)"
read UserInput

if [ $UserInput = 1 ]
then
    reboot
else
    echo "Please reboot at your earliest conviniance"
fi
