#!/bin/sh

# Prepare Spotify installation
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
echo deb http://repository.spotify.com stable non-free | tee /etc/apt/sources.list.d/spotify.list

# Prepare Docker installation /!\ configured for ubuntu
apt-get remove docker docker-engine docker.io
apt-get install			\
     apt-transport-https	\
     ca-certificates		\
     curl			\
     gnupg2			\
     software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository		\
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs)		\
   stable"

# Prepare Telegram installation

add-apt-repository -y ppa:atareao/telegram

# Update installation
apt update && apt upgrade -y

# Apply installation
apt update
apt install -y			\
	chromium-browser	\
	git			\
	spotify-client		\
	docker-ce		\
	docker-compose		\
	libsfml-dev		\
	g++			\
	telegram		\
	libappindicator1	\
	valgrind		\
	htop

# Install CLION

wget -O /tmp/clion.tar.gz "https://download.jetbrains.com/cpp/CLion-2017.1.3.tar.gz"
cd $1
tar -zxvf /tmp/clion.tar.gz

# Install discord

wget -O /tmp/discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
dpkg -i /tmp/discord.deb

echo "Installation completed. Don't forget to finish installing clion"
