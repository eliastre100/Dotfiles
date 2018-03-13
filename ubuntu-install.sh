#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Setup Spotify repositories
ls /etc/apt/sources.list.d/spotify.list &> /dev/null
if [ $? -ne 0 ]; then
	echo "Adding Spotify repositories"
	sh -c 'echo "deb http://repository.spotify.com stable non-free" >> /etc/apt/sources.list.d/spotify.list' >> dump.log
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0DF731E45CE24F27EEEB1450EFDC8610341D9410 >> dump.log
fi

# Setup telegram repository
grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep telegram &> /dev/null
if [ $? -ne 0 ]; then
	echo "Adding Telegram PPA"
	add-apt-repository -y ppa:atareao/telegram >> dump.log
fi

# Setup Sublime Text repository
ls /etc/apt/sources.list.d/sublime-text.list &> /dev/null
if [ $? -ne 0 ]; then
	echo "Adding Sublime text repositories"
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - >> dump.log
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list >> dump.log
fi

# Install packets from repositories
echo "Updating repositories"
apt -y update
echo "Installing base packets"
apt -y install git \
	spotify-client \
	chromium-browser \
	telegram \
	valgrind \
	htop \
	wget \
	telegram \
	make \
	zsh \
	ruby-build \
	apt-transport-https \
	sublime-text \
	cmdtest

echo "Installing rbenv"
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
cd ~/.rbenv && src/configure && make -C src
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
~/.rbenv/bin/rbenv init

echo "Installing nvm"
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash

echo "Installing MailSpring"
wget -O /tmp/mailspring.deb https://updates.getmailspring.com/download?platform=linuxDeb
dpkg -i /tmp/mailspring.deb

apt -y -f install
