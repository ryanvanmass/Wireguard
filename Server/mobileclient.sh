#!/bin/bash
############### Create Directory Structure ###############
echo "What is the Client Name?"
read ClientName

mkdir -p /etc/wireguard/'Mobile Clients'/$ClientName

############### Generate Client Keys ###############
wg genkey | tee /etc/wireguard/'Mobile Clients'/$ClientName/client_private_key | wg pubkey > /etc/wireguard/'Mobile Clients'/$ClientName/client_public_key

############### Create Configuration File ###############
#Creates the File
touch /etc/wireguard/'Mobile Clients'/$ClientName/client.conf

#Variables for next step
PrivateKey=$(cat /etc/wireguard/'Mobile Clients'/$ClientName/client_private_key)

ServerKey=$(cat /etc/wireguard/server_public_key)

ServerIP=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

echo "what would you like the Client IP to be (10.100.100.?/32)?"
read ClientIP

#Configure File
echo "[Interface]" >> /etc/wireguard/'Mobile Clients'/$ClientName/client.conf
echo "Address = 10.100.100.$ClientIP/32 " >> /etc/wireguard/'Mobile Clients'/$ClientName/client.conf
echo "DNS = 8.8.8.8" >> /etc/wireguard/'Mobile Clients'/$ClientName/client.conf
echo "PrivateKey = $PrivateKey" >> /etc/wireguard/'Mobile Clients'/$ClientName/client.conf
echo " " >> /etc/wireguard/'Mobile Clients'/$ClientName/client.conf
echo "[Peer]" >> /etc/wireguard/'Mobile Clients'/$ClientName/client.conf
echo "PublicKey = $ServerKey" >> /etc/wireguard/'Mobile Clients'/$ClientName/client.conf
echo "Endpoint = $ServerIP:51820" >> /etc/wireguard/'Mobile Clients'/$ClientName/client.conf
echo "AllowedIPs = 0.0.0.0/0" >> /etc/wireguard/'Mobile Clients'/$ClientName/client.conf
echo "PersistentKeepalive = 21" >> /etc/wireguard/'Mobile Clients'/$ClientName/client.conf

############### Confirm Client.conf looks good ###############
cat /etc/wireguard/'Mobile Clients'/$ClientName/client.conf
echo "Is the Client Configuration correct?"
echo "(1 for yes or 2 for no)"
read UserInput

if [ $UserInput = 2 ]
then
    nano /etc/wireguard/'Mobile Clients'/$ClientName/client.conf
fi



############### Adds Client to server ###############
PublicKey=$(cat /etc/wireguard/'Mobile Clients'/$ClientName/client_public_key)
wg set wg0 peer $PublicKey allowed-ips 10.100.100.$ClientIP/32

############### Generate QR Code ###############
qrencode -t ansiutf8 < /etc/wireguard/'Mobile Clients'/$ClientName/client.conf
