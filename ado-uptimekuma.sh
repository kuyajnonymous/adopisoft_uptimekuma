#!/bin/bash

# Update and install necessary packages
apt-get update
apt-get install -y curl sudo mc git ca-certificates gnupg

# Set up NodeSource repository for Node.js
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs

# Clone the Uptime Kuma repository and set it up
git clone https://github.com/louislam/uptime-kuma.git /opt/uptime-kuma
cd /opt/uptime-kuma
npm install
npm run setup

# Create a dedicated user for the service
sudo useradd -r -m -U -d /opt/uptime-kuma uptime-kuma

# Create a systemd service file for Uptime Kuma
cat <<EOL > /etc/systemd/system/uptime-kuma.service
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
systemctl daemon-reload
systemctl enable --now uptime-kuma.service

echo "Uptime Kuma installation and setup completed."
