#!/usr/bin/env bash

run_mac(){
    # free port 3000 & 4000
    kill -9 $( lsof -i:3000 -t)
    kill -9 $( lsof -i:4000 -t)
    dir=~/iot_inspector

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

    if [ ! -d "$dir" ]; then
        echo "$dir does not exist."
        git clone https://github.com/nyu-mlab/iot-inspector-client.git $dir
        cd ~/iot_inspector
        git checkout cr-dev
    fi

    ## run python driver
    cd $dir
    pip3 install -r requirements.txt > /dev/null
    ## pending run python driver TODO

    ## run node scripts
    cd ~/iot_inspector/ui/default
    yarn install:all
    yarn clean:db
    yarn prisma:generate
    yarn mockdb > /dev/null &
    yarn dev > /dev/null &

    echo "app running on http://localhost:3000"
    open -a "Google Chrome" http://localhost:3000
}

run_linux(){
 # free port 3000 & 4000
    kill -9 $( lsof -i:3000 -t)
    kill -9 $( lsof -i:4000 -t)
    dir=~/iot_inspector

    if test ! $(which python3); then
        sudo apt-get update
        echo "Installing python3..."
        ruby -e "$(sudo apt-get install python3.9)"
    fi

    if test ! $(which node); then
        echo "Installing nodejs..."
        ruby -e "$(sudo apt-get install nodejs)"
    fi

    if test ! $(which yarn); then
        echo "Intalling yarn..."
        npm install --global yarn
    fi

    if test ! $(which git); then
        echo "Installing git..."
        ruby -e "$(sudo apt-get install git)"
    fi

    if [ ! -d "$dir" ]; then
        echo "$dir does not exist."
        git clone https://github.com/nyu-mlab/iot-inspector-client.git $dir
        cd ~/iot_inspector
        git checkout cr-dev
    fi

    ## run python driver
    cd ~/iot_inspector/inspector
    pip3 install -r requirements.txt > /dev/null
    ## pending run python driver TODO

    ## run node scripts
    cd ~/iot_inspector/ui/default
    yarn install:all
    yarn clean:db
    yarn prisma:generate
    yarn mockdb > /dev/null &
    yarn dev > /dev/null &

    echo "app running on http://localhost:3000"
    google-chrome http://localhost:3000
}
if [ "$(uname)" == "Darwin" ]; then
    # Do something under Mac OS X platform    
    run_mac    
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Do something under GNU/Linux platform
    run_linux
fi
