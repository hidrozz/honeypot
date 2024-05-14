#!/bin/bash

# Step 0: Update and Upgrade
echo "Updating and upgrading system packages..."
sudo apt-get update && sudo apt-get upgrade -y

# Step 1: Install system dependencies
echo "Installing system dependencies..."
sudo apt-get install -y git python3-virtualenv libssl-dev libffi-dev build-essential libpython3-dev python3-minimal authbind virtualenv

# Step 2: Create a user account
echo "Creating user account..."
sudo adduser --disabled-password cowrie

# Step 3: Checkout the code
echo "Checking out the code..."
sudo -u cowrie git clone http://github.com/cowrie/cowrie /home/cowrie/cowrie

# Step 4: Setup Virtual Environment
echo "Setting up virtual environment..."
sudo -u cowrie bash -c 'cd /home/cowrie/cowrie && python3 -m venv cowrie-env'

# Step 5: Activate the virtual environment and update pip, install requirements
echo "Activating virtual environment and installing packages..."
sudo -u cowrie bash -c 'source /home/cowrie/cowrie/cowrie-env/bin/activate && python -m pip install --upgrade pip && python -m pip install --upgrade -r /home/cowrie/cowrie/requirements.txt'

# Step 6: Start Cowrie
echo "Starting Cowrie..."
sudo -u cowrie bash -c 'source /home/cowrie/cowrie/cowrie-env/bin/activate && cd /home/cowrie/cowrie && bin/cowrie start'

echo "Installation and startup complete."
