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

# Log in to MySQL
echo "[+] Creating MySQL Database"

mysql -u root <<MYSQL_SCRIPT
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

INSERT INTO users (username, password) VALUES ('admin', 'password123');

FLUSH PRIVILEGES;
MYSQL_SCRIPT

# Create a Vulnerable Web Application
echo "[+] Creating Web App"

rm -rf /var/www/html/index.html
cp index.php /var/www/html/

touch /var/www/html/access_log.php
chmod 666 /var/www/html/access_log.php
chown www-data:www-data /var/www/html/access_log.php
cp apache2.conf /etc/apache2/
cp 000-default.conf /etc/apache2/sites-available/
systemctl restart apache2

# Insecure Services
# Configure the FTP server
echo "[+] Configuring FTP"

apt install -y vsftpd
systemctl enable vsftpd
cp vsftpd.conf /etc/
cp adminnote.txt /srv/ftp/
systemctl start vsftpd
systemctl restart vsftpd

# Weak Passwords
echo "[+] Adding User"

useradd -m -p $(openssl passwd -1 password123) weakuser
adduser weakuser sudo


# Add Flags
echo "[+] Dropping flags"
echo "30fb71445c24c68e6025df305b03b635" > /root/proof.txt
echo "c385595700173861809d7685bcccf997" > /home/weakuser/local.txt
chmod 0700 /root/proof.txt
chmod 0644 /home/weakuser/local.txt
chown weakuser:weakuser /home/weakuser/local.txt 


# Clean up files
echo "[+] Cleaning up"
rm -rf /root/build.sh
rm -rf /root/index.php
rm -rf /root/vsftpd.conf
rm -rf /root/000-default.conf
rm -rf /root/adminnote.txt
rm -rf /root/apache2.conf

echo "[+] Disabling history files"
cat /dev/null > /home/weakuser/.bash_history && history -c && exit
cat /dev/null > /root/.bash_history && history -c && init 0