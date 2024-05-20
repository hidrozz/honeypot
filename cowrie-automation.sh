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

# Install Prometheus Node Exporter
echo "Installing Prometheus Node Exporter..."
wget https://github.com/prometheus/node_exporter/releases/download/v1.8.0/node_exporter-1.8.0.linux-arm64.tar.gz
tar xvfz node_exporter-1.8.0.linux-arm64.tar.gz
sudo mv node_exporter-1.8.0.linux-arm64/node_exporter /usr/local/bin/

# Create node_exporter user
echo "Creating node_exporter user..."
sudo useradd -rs /bin/false node_exporter

# Create systemd service file for node_exporter
echo "Creating systemd service file for Node Exporter..."
sudo tee /etc/systemd/system/node_exporter.service<<EOF
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

# Start and enable node_exporter service
echo "Starting and enabling Node Exporter service..."
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter

# Check node_exporter service status
echo "Checking Node Exporter service status..."
sudo systemctl status node_exporter

echo "Node Exporter installation and setup complete."
