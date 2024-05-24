# Linux_CTF_Example

This virtual machine is designed specifically for Capture The Flag (CTF) challenges, featuring multiple intentional vulnerabilities for educational and testing purposes. It runs on Ubuntu Server with essential tools like Apache, PHP, and MySQL installed. The machine includes a vulnerable web application susceptible to SQL injection, insecure services such as FTP, and users with weak passwords. Ideal for cybersecurity enthusiasts looking to sharpen their penetration testing skills in a controlled environment. 

## Required Settings

**CPU**: 1 CPU  
**Memory**: 2GB  
**Disk**: 10GB

## Build Guide

1. Install Ubuntu Server 20.04.6 LTS
2. Enable network connectivity
3. Ensure machine is fully updated by running `apt-get update`
4. Upload the following files to `/root`
    - `build.sh`
    - `index.php`
    - `vsftpd.conf`
    - `000-default.conf`
    - `adminnote.txt`
    - `apache2.conf`
5. Change to `/root` and run `build.sh`