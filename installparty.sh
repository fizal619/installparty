echo "~~~~~~~~~~~~~~~"
echo "INSTALL PARTY!"
echo "~~~~~~~~~~~~~~~"
echo "Any concerns or issues with this script? 
Contact Fizal Sarif, Isaac Kang, or Daniel Yochum on slack.
"
sleep 2

echo "This will install all the essential stuff you'll need to get started."
echo "Like git, ruby, node, sublime, google chrome, etc."
echo "Plus do a little housekeeping! So make sure to enter your password wherever it asks."
sleep 4

cd ~

echo ""
echo -n "Enter your computer's password so I can install a few things for you > "
read password

echo $password | sudo -S apt-get update
sudo apt-get -y install wget

wget -O sublime.deb https://download.sublimetext.com/sublime-text_build-3126_amd64.deb
sudo dpkg -i sublime.deb
rm sublime.deb

wget -O google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome.deb
rm google-chrome.deb
sudo apt-get install -y -f

wget -O atom.deb https://atom.io/download/deb
sudo dpkg -i atom.deb
rm atom.deb
sudo apt-get install -y -f

wget -O slack.deb https://downloads.slack-edge.com/linux_releases/slack-desktop-2.5.2-amd64.deb
sudo dpkg -i slack.deb
rm slack.deb
sudo apt-get install -y -f

sudo apt-get -y install terminator
sudo apt-get install -y curl
sudo apt-get install -y git

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash
source ~/.bashrc

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

nvm -v 
nvm install stable
nvm use stable

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io -o rvm.sh
cat rvm.sh | bash -s stable --rails
rm rvm.sh
echo "source ~/.rvm/scripts/rvm" >> ~/.bashrc
echo progress-bar >> ~/.curlrc
gem install bundler

git clone https://github.com/magicmonty/bash-git-prompt.git .bash-git-prompt --depth=1
echo "GIT_PROMPT_ONLY_IN_REPO=1" >> ~/.bashrc
echo "GIT_PROMPT_THEME=Default_Ubuntu" >> ~/.bashrc
echo "source ~/.bash-git-prompt/gitprompt.sh" >> ~/.bashrc

echo $password | sudo -S apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
sudo apt-get update
sudo apt-get install -y mongodb-org

echo $password | sudo -S touch /etc/systemd/system/mongodb.service
echo "[Unit]
Description=High-performance, schema-free document-oriented database
After=network.target

[Service]
User=mongodb
ExecStart=/usr/bin/mongod --quiet --config /etc/mongod.conf

[Install]
WantedBy=multi-user.target" > mongodb.service
sudo mv mongodb.service /etc/systemd/system/mongodb.service
rm mongodb.service
sudo systemctl start mongodb

sudo apt-get install -y postgresql postgresql-contrib
sudo -u postgres bash -c "psql -c \"CREATE ROLE $(whoami) WITH PASSWORD '$password' SUPERUSER CREATEDB CREATEROLE LOGIN;\""
createdb "$(whoami)"

echo "alias gst=\"git status -sb\"
alias gcm=\"git commit -m\"
alias gpom=\"git push origin master\"
alias gpo=\"git push origin\"
alias gAA=\"git add -A\"
alias ga=\"git add\"
alias gam=\"git add .\"
alias gco=\"git checkout\"
alias gcob=\"git checkout -b\"" >> ~/.bashrc

echo ""
echo "======================================"
echo "              AWESOME!"
echo "======================================"
echo "Now close this terminal window and 
open a new one. Enjoy!"
echo "======================================"