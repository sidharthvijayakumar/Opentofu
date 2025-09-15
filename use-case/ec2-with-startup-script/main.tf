resource "aws_security_group" "spot_security_group" {
  name        = "spot-instance"
  description = "Security group for the vm spot instance"
  vpc_id      = "vpc-750ffb1e" # Replace with your VPC ID

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["58.84.61.83/32"] # Be cautious with 0.0.0.0/0 in production
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["58.84.61.83/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
}

module "ec2_spot_instance" {
  source = "./modules/ec2"

  name                   = "spot-instance"
  ami                    = "ami-02d26659fd82cf299"
  create_spot_instance   = true
  spot_price             = "0.60"
  spot_type              = "persistent"
  create_security_group  = false
  instance_type          = "t3.micro"
  key_name               = "demo-key-pair"
  monitoring             = true
  subnet_id              = "subnet-f83faa83"
  user_data              = <<-EOF
              #!/bin/bash
              sudo apt update

              sudo apt install default-jdk -y

              mkdir ~/tmp
              cd ~/tmp
              wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.24/bin/apache-tomcat-10.1.24.tar.gz
              sudo tar -xzvf apache-tomcat-10*tar.gz -C /opt/tomcat --strip-components=1
              sudo chown -R tomcat:tomcat /opt/tomcat/
              sudo chmod -R u+x /opt/tomcat/bin

              sudo tee -a /opt/tomcat/conf/tomcat-users.xml > /dev/null <<"EOF"

              <!-- Filename: /opt/tomcat/conf/tomcat-users.xml --> 

              <role rolename="manager-gui" />
              <user username="manager" password="password" roles="manager-gui" />

              <role rolename="admin-gui" />
              <user username="admin" password="password" roles="manager-gui,admin-gui" />
              "EOF"

              sudo update-java-alternatives -l

              sudo tee -a /etc/systemd/system/tomcat.service > /dev/null <<"EOF"
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
              "EOF"

              sudo systemctl daemon-reload

              sudo systemctl start tomcat

              sudo systemctl status tomcat

              EOF
  vpc_security_group_ids = [aws_security_group.spot_security_group.id]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

