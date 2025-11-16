#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd

echo "The page was created by the user data and Andrii Dukhvin" > /var/www/html/index.html
