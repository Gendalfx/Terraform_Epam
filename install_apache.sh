#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd

cat > /var/www/html/index.html <<EOF
<html>
  <body style="background-color: ${color}; font-size: 30px; color: white;">
    Server index: ${index}<br>
    Color: ${color}<br>
    Created by Andrii Dukhvin
  </body>
</html>
EOF
