#!/bin/bash

echo "updating system"

apt update
apt upgrade -y

#install packages

echo "installing packages"

apt install \
git\
python3-virtualenv\
libssl-dev\
libffi-dev\
build-essential\
libpython3-dev\
python3-minimal\
authbind\
virtualenv\
-y

echo "downloading cowrie"
git clone http://github.com/cowrie/cowrie

cd cowrie || exit

# Create and activate virtual environment
echo "Setting up virtual environment"
python3 -m venv cowrie-env
source cowrie-env/bin/activate

# Update pip and install requirements
echo "Updating pip and installing cowrie requirements"
python -m pip install --upgrade pip
python -m pip install --upgrade -r requirements.txt

# Start cowrie
echo "Starting cowrie"
bin/cowrie start
