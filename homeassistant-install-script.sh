#!/bin/bash

sudo apt update
sudo apt install -y apparmor cifs-utils curl dbus jq libglib2.0-bin lsb-release network-manager nfs-common systemd-journal-remote systemd-resolved udisks2 wget uidmap
if ![ command -v docker &> /dev/null]; then
    echo "docker could not be found"
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
else
    echo "docker is installed"
fi

dockerd-rootless-setuptool.sh install
export PATH=/usr/bin:$PATH
export DOCKER_HOST=unix:///run/user/1000/docker.sock

# Get the latest release page
release_url="https://github.com/home-assistant/os-agent/releases/latest"
release_page=$(curl -sL $release_url)

# Extract the latest version number from the release page
latest_version=$(echo "$release_page" | grep -oP 'href="/home-assistant/os-agent/releases/tag/\K[^"]+')

# Detect the system architecture
arch=$(uname -m)

case $arch in
  x86_64)
    arch="x86_64"
    ;;
  i686 | i386)
    arch="386"
    ;;
  aarch64)
    arch="arm64"
    ;;
  armv5*)
    arch="armv5"
    ;;
  armv6*)
    arch="armv6"
    ;;
  armv7*)
    arch="armv7"
    ;;
  *)
    echo "Unsupported architecture: $arch"
    exit 1
    ;;
esac

# Construct the download URL based on architecture
base_url="https://github.com/home-assistant/os-agent/releases/download/$latest_version"
#         https://github.com/home-assistant/os-agent/releases/download/1.6.0/os-agent_1.6.0_linux_x86_64.deb
file_url="$base_url/os-agent_${latest_version}_linux_${arch}.deb"
echo $lates_version
echo $file_url
filepath="os-agent_${latest_version}_linux_${arch}.deb"

# Download the file
wget $file_url
sudo dpkg -i $filepath
echo "Downloaded $file_url"


wget -O homeassistant-supervised.deb https://github.com/home-assistant/supervised-installer/releases/latest/download/homeassistant-supervised.deb
sudo apt install ./homeassistant-supervised.deb
