#!/bin/bash
############### Collect User Input ###############
echo "What is the Client Public Key?"
read ClientKey

echo "What is the Clients allowed IP address?"
read ClientIP

############### Adds Client ###############
wg set wg0 peer $ClientKey allowed-ips $ClientIP