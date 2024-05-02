#!/bin/bash

sudo apt-get install git python3-virtualenv libssl-dev libffi-dev build-essential libpython3-dev python3-minimal authbind virtualenv

git clone http://github.com/cowrie/cowrie

cd cowrie

pwd
python -m venv cowrie-env

source cowrie-env/bin/activate
python -m pip install --upgrade pip
python -m pip install --upgrade -r requirements.txt

bin/cowrie start