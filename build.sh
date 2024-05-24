sudo apt install -y build-essential git wget curl net-tools
sudo apt install -y apache2 php libapache2-mod-php mysql-server php-mysql
sudo mysql_secure_installation

# Log in to MySQL
sudo mysql -u root -p

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

sudo systemctl restart apache2

sudo apt install -y vsftpd

sudo systemctl enable vsftpd

mv /mnt/hgfs/MyShare/vsftpd.conf /etc/

sudo systemctl start vsftpd


sudo useradd -m -p $(openssl passwd -1 password123) weakuser