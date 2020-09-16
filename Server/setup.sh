#!/bin/bash
############### Dependancies Install ###############
sudo add-apt-repository ppa:wireguard/wireguard
sudo apt-get update
sudo apt-get install -y qrencode wireguard-dkms wireguard-tools linux-headers-$(uname -r)

############### Generate Certificates ###############
umask 077
wg genkey | tee /etc/wireguard/server_private_key | wg pubkey > /etc/wireguard/server_public_key

############### Create Server Config ###############
#Creates the File
touch /etc/wireguard/wg0.conf

#Variables for next step
PrivateKey=$(cat /etc/wireguard/server_private_key)

#Configures the File
echo "[Interface]" >> /etc/wireguard/wg0.conf
echo "Address = 10.100.100.1/24 " >> /etc/wireguard/wg0.conf
echo "SaveConfig = true " >> /etc/wireguard/wg0.conf
echo "PrivateKey = $PrivateKey" >> /etc/wireguard/wg0.conf
echo "ListenPort = 51820 " >> /etc/wireguard/wg0.conf
echo "PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE " >> /etc/wireguard/wg0.conf
echo " " >> /etc/wireguard/wg0.conf
echo "PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE " >> /etc/wireguard/wg0.conf
echo " " >> /etc/wireguard/wg0.conf

############### Enable IP forwarding ###############
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl net.ipv4.ip_forward=1

############### Start WireGuard ###############
chown -v root:root /etc/wireguard/wg0.conf
chmod -v 600 /etc/wireguard/wg0.conf
wg-quick up wg0
systemctl enable wg-quick@wg0.service

############### Provide Necessary Information for Client Connections ###############
#Variables for Printing the required Information
PublicKey=$(cat /etc/wireguard/server_public_key)

ServerIP=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

#Creates File
echo "INFORMATION FOR CONNECTING CLIENTS" >> ServerInformation.txt
echo "----------------------------------" >> ServerInformation.txt
echo "" >> ServerInformation.txt
echo "Server IP: $ServerIP" >> ServerInformation.txt
echo "Server Public Key: $PublicKey" >> ServerInformation.txt

#Prints file to Terminal
clear
cat ServerInformation.txt

############### Restarts Server ###############
echo "It is recommended that you restart the Server. Would you like to do this now? (1 for yes or 2 for no)"
read UserInput

if [ $UserInput = 1 ]
then
    reboot
else
    echo "Please reboot at your earliest conviniance"
fi