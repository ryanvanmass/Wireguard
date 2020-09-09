#!/bin/bash
############### Dependancies Install ###############
sudo add-apt-repository ppa:wireguard/wireguard
sudo apt-get update
sudo apt-get install wireguard-dkms wireguard-tools linux-headers-$(uname -r)

############### Generate Certificates ###############
cd /etc/wireguard/
pwd
umask 077
wg genkey | tee server_private_key | wg pubkey > server_public_key

############### Create Server Config ###############
#Creates the File
touch wg0.conf

#Variables for next step
PrivateKey=$(cat server_private_key)

#Configures the File
echo "[Interface]" >> wg0.conf
echo "Address = 10.100.100.1/24 " >> wg0.conf
echo "SaveConfig = true " >> wg0.conf
echo "PrivateKey =  $PrivateKey" >> wg0.conf
echo "ListenPort = 51820 " >> wg0.conf
echo "PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE " >> wg0.conf
echo " " >> wg0.conf
echo "PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE " >> wg0.conf
echo " " >> wg0.conf

############### Enable IP forwarding ###############
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl net.ipv4.ip_forward=1

############### Start WireGuard ###############
chown -v root:root /etc/wireguard/wg0.conf
chmod -v 600 /etc/wireguard/wg0.conf
wg-quick up wg0
systemctl enable wg-quick@wg0.service 