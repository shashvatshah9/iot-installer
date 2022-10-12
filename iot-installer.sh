#!/usr/bin/env bash

run_mac(){
    if test ! $(which brew); then 
        echo "Installing homebrew..." 
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" 
        echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
    fi

    if test ! $(which python3); then
        echo "Installing python3..."
        ruby -e "$(brew install python3)"
    fi

    if test ! $(which node); then
        echo "Installing nodejs..."
        ruby -e "$(brew install node)"
    fi

    if test ! $(which yarn); then
        echo "Intalling yarn..."
        npm install --global yarn
    fi

    if test ! $(which git); then
        echo "Installing git..."
        ruby -e "$(brew install git)"
    fi

    if [ ! -d "~/iot_inspector" ]; then
        echo "$DIRECTORY does exist."
        git clone https://github.com/nyu-mlab/iot-inspector-client.git ~/iot_inspector
        cd ~/iot_inspector
        git checkout cr-dev
    fi

    ## run python driver
    cd ~/iot_inspector/inspector
    pip3 install -r requirements.txt
    ## pending run python driver TODO

    ## run node scripts
    cd ~/iot_inspector/ui/default
    yarn install:all
    yarn clean:db
    yarn prisma:generate
    yarn mockdb > /dev/null &
    yarn dev &
}

# curl "https://nodejs.org/dist/latest/node-${VERSION:-$(wget -qO- https://nodejs.org/dist/latest/ | sed -nE 's|.*>node-(.*)\.pkg</a>.*|\1|p')}.pkg" > "$HOME/Downloads/node-latest.pkg" && sudo installer -store -pkg "$HOME/Downloads/node-latest.pkg" -target "/"

run_mac