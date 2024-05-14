#!/bin/bash

# Step 0: Update and Upgrade
echo "Updating and upgrading system packages..."
sudo apt-get update -y && sudo apt-get upgrade -y

# Step 1: Install system dependencies
echo "Installing system dependencies..."
sudo apt-get install -y git python3-venv libssl-dev libffi-dev build-essential libpython3-dev python3-minimal authbind

# Step 2: Create a user account
echo "Creating user account..."
sudo adduser --disabled-password --gecos "" cowrie

# Step 3: Checkout the code
echo "Cloning Cowrie repository..."
sudo -u cowrie git clone https://github.com/cowrie/cowrie /home/cowrie/cowrie

# Step 4: Setup Virtual Environment
echo "Setting up virtual environment..."
sudo -u cowrie python3 -m venv /home/cowrie/cowrie/cowrie-env

# Step 5: Activate the virtual environment and update pip, install requirements
echo "Activating virtual environment and installing packages..."
sudo -u cowrie /bin/bash -c 'source /home/cowrie/cowrie/cowrie-env/bin/activate && pip install --upgrade pip && pip install -r /home/cowrie/cowrie/requirements.txt'

# Step 6: Start Cowrie
echo "Starting Cowrie..."
sudo -u cowrie /bin/bash -c 'source /home/cowrie/cowrie/cowrie-env/bin/activate && cd /home/cowrie/cowrie && bin/cowrie start'

echo "Installation and startup complete."

# Optional: Display Cowrie log
echo "Displaying Cowrie log..."
sudo -u cowrie tail -n 10 /home/cowrie/cowrie/var/log/cowrie/cowrie.log
