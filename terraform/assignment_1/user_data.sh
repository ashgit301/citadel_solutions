#!/bin/sh
sudo yum update -y > userdata.txt
sudo amazon-linux-extras install -y php7.2 >> userdata.txt
sudo yum install -y httpd >> userdata.txt
sudo systemctl start httpd >> userdata.txt
sudo systemctl enable httpd >> userdata.txt
sudo usermod -a -G apache ec2-user >> userdata.txt
sudo chown -R ec2-user:apache /var/www >> userdata.txt
sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \; >> userdata.txt
find /var/www -type f -exec sudo chmod 0664 {} \; >> userdata.txt
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
cd /var/www/html && wp core download >> userdata.txt

