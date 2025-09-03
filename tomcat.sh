#!/bin/sh
sudo apt update

sudo apt install default-jdk -y

mkdir ~/tmp
cd ~/tmp
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.24/bin/apache-tomcat-10.1.24.tar.gz
sudo tar -xzvf apache-tomcat-10*tar.gz -C /opt/tomcat --strip-components=1
sudo chown -R tomcat:tomcat /opt/tomcat/
sudo chmod -R u+x /opt/tomcat/bin

sudo cat <<EOF | tee -a /opt/tomcat/conf/tomcat-users.xml

sudo tee -a /opt/tomcat/conf/tomcat-users.xml > /dev/null <<‘EOF’

<!-- Filename: /opt/tomcat/conf/tomcat-users.xml --> 

<role rolename="manager-gui" />
<user username="manager" password="password" roles="manager-gui" />

<role rolename="admin-gui" />
<user username="admin" password="password" roles="manager-gui,admin-gui" />
EOF

sudo update-java-alternatives -l

sudo tee -a /etc/systemd/system/tomcat.service > /dev/null <<'EOF'
[Unit]
Description=Tomcat
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=/usr/lib/jvm/java-1.21.0-openjdk-amd64/"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"
Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload

sudo systemctl start tomcat

sudo systemctl status tomcat