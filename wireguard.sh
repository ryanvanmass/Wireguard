#!/bin/bash
############### Device Selection ###############
echo "Select one of the following:"
echo "1. Server Configurator"
echo "2. Client Configurator"
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
