#!/bin/bash
############### Device Selection ###############
echo "Select one of the following:"
echo "1. Server"
echo "2. Client"
echo "3. Add Device"
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
else
    echo "Error Invalid Input"
fi
