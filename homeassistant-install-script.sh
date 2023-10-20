sudo apt update && sudo apt upgrade -y -qq


curl -fsSL get.docker.com | sh

#curl -fsSL https://get.docker.com -o get-docker.sh
#sh get-docker.sh

apt-get install -y uidmap -qq

sudo dockerd-rootless-setuptool.sh install

sudo groupadd docker
sudo usermod -aG docker ubuntu

docker volume create portainer_data
docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:2.19.1

sudo apt-get install jq wget curl udisks2 libglib2.0-bin network-manager dbus -y -qq

wget https://github.com/home-assistant/os-agent/releases/download/1.6.0/os-agent_1.6.0_linux_aarch64.deb
sudo dpkg -i os-agent_1.3.0_linux_aarch64.deb

wget https://github.com/home-assistant/supervised-installer/releases/download/1.5.0/homeassistant-supervised.deb
sudo dpkg -i homeassistant-supervised.deb

#important for unsupported systems
ha jobs options --ignore-conditions healthy