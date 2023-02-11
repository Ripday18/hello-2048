#!/bin/sh
amazon-linux-extras install -y docker
service docker start
systemctl enable docker
usermod -a -G docker ec2-user
pip3 install docker-compose
