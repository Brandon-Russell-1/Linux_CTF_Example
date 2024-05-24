#!/usr/bin/env bash
set -e

#
# Note: It is assumed that the build script will be run as the root user.
#

# Update and Upgrade
echo "[+] Updating"

apt update && apt upgrade -y

# Install Essential Tools
echo "[+] Installing tools"

apt install -y build-essential git wget curl net-tools
apt install -y apache2 php libapache2-mod-php mysql-server php-mysql
mysql_secure_installation

# Log in to MySQL
echo "[+] Creating MySQL Database"

mysql -u root -p

# Create a database and user
CREATE DATABASE ctf_db;
CREATE USER 'ctf_user'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON ctf_db.* TO 'ctf_user'@'localhost';

use ctf_db;

CREATE TABLE users (  
id INT AUTO_INCREMENT,  
username VARCHAR(255) NOT NULL,  
password VARCHAR(255) NOT NULL,  
PRIMARY KEY (id)  
);

INSERT INTO users (username, password) VALUES (‘admin’, ‘password123’);

FLUSH PRIVILEGES;
EXIT;

# Create a Vulnerable Web Application
echo "[+] Creating Web App"

rm -rf /var/www/html/index.html
cp index.php /var/www/html/

systemctl restart apache2

# Insecure Services
# Configure the FTP server
echo "[+] Configuring FTP"

apt install -y vsftpd
systemctl enable vsftpd
cp vsftpd.conf /etc/
systemctl start vsftpd

# Weak Passwords
echo "[+] Adding User"

useradd -m -p $(openssl passwd -1 password123) weakuser

# Clean up files
echo "[+] Cleaning up"
rm -rf /root/build.sh
rm -rf /root/index.php
rm -rf /root/vsftpd.conf
