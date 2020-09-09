#!/bin/bash
#!/bin/bash
############### Dependancies Install ###############
sudo add-apt-repository ppa:wireguard/wireguard
sudo apt-get update
sudo apt-get install wireguard-dkms wireguard-tools linux-headers-$(uname -r)

############### Generate Certificates ###############
cd /etc/wireguard/
pwd
wg genkey | tee client_private_key | wg pubkey > client_public_key

############### Create Configuration File ###############
#Creates the File
touch wg0-client.conf

#Variables for next step
PrivateKey=$(cat client_private_key)

echo "What is the Server Public Key?"
read ServerKey

echo "what is the Server IP address"
read ServerIP

echo "what would you like the Client IP to be (10.100.100.?/32)?"
read ClientIP

#Configure File
echo "[Interface]" >> wg0-client.conf
echo "Address = 10.100.100.$ClientIP/32" >> wg0-client.conf
echo "PrivateKey = $PrivateKey" >> wg0-client.conf
echo " " >> wg0-client.conf
echo "[Peer]" >> wg0-client.conf
echo "PublicKey = $ServerKey" >> wg0-client.conf
echo "Endpoint = $ServerIP:51820" >> wg0-client.conf
echo "AllowedIPs = 0.0.0.0/0" >> wg0-client.conf
echo "PersistentKeepalive = 21" >> wg0-client.conf

############### Start WireGuard ###############
sudo wg-quack up wg0-client
sudo systemctl enable wg-quack@wg0-client