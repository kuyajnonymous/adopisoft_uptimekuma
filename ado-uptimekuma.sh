#!/bin/bash

# Update and install necessary packages
sudo apt-get update
sudo apt-get install -y curl sudo mc git ca-certificates gnupg

# Set up NodeSource repository for Node.js
sudo curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs

# Clone the Uptime Kuma repository and set it up
sudo git clone https://github.com/louislam/uptime-kuma.git /opt/uptime-kuma
cd /opt/uptime-kuma
sudo npm install
sudo npm run setup

# Create a dedicated user for the service
sudo useradd -r -m -U -d /opt/uptime-kuma uptime-kuma

# Create a systemd service file for Uptime Kuma
sudo cat <<EOL > /etc/systemd/system/uptime-kuma.service
[Unit]
Description=uptime-kuma

[Service]
Type=simple
Restart=always
User=uptime-kuma
WorkingDirectory=/opt/uptime-kuma
ExecStart=/usr/bin/npm start

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd and start the Uptime Kuma service
sudo systemctl daemon-reload
sudo systemctl enable --now uptime-kuma.service

echo "Uptime Kuma installation and setup completed."
