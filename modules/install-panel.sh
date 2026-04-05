#!/bin/bash

# Prompt for user settings
echo "Welcome to the Panel Installation Script!"
read -p "Enter your domain (e.g., example.com): " DOMAIN
read -p "Enter the port number (default 80): " PORT
PORT=${PORT:-80}
read -p "Enter your admin email: " ADMIN_EMAIL
read -sp "Enter your password: " PASSWORD
echo -e "\n"
read -p "Enter database type (PostgreSQL/MongoDB): " DB_TYPE

# Update package list and install necessary dependencies
sudo apt update
sudo apt install -y curl gnupg2 software-properties-common

# Install Node.js
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install -y nodejs

# Install Docker
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y docker-ce

# Install PostgreSQL or MongoDB based on user choice
if [[ "$DB_TYPE" == "PostgreSQL" ]]; then
    sudo apt install -y postgresql postgresql-contrib
elif [[ "$DB_TYPE" == "MongoDB" ]]; then
    wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
    sudo apt update
    sudo apt install -y mongodb-org
else
    echo "Invalid database type selected!"
    exit 1
fi

# Install Nginx
sudo apt install -y nginx

# Obtain and configure SSL certificate
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d "$DOMAIN" --non-interactive --agree-tos --email "$ADMIN_EMAIL"

# Configure UFW
sudo ufw allow OpenSSH
sudo ufw allow "$PORT"
sudo ufw enable

# Install Fail2Ban
sudo apt install -y fail2ban

# Create Fail2Ban local configuration
echo "[DEFAULT]" | sudo tee /etc/fail2ban/jail.local
echo "bantime = 1h" | sudo tee -a /etc/fail2ban/jail.local

# Start and enable services
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl start fail2ban
sudo systemctl enable fail2ban

echo "Panel installation completed successfully!"