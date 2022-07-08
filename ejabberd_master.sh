#!/bin/bash

sudo apt update -y
sudo apt install docker.io -y
sudo usermod -aG docker ubuntu
sudo systemctl start docker
sudo systemctl enable docker

#tee -a /home/ubuntu/docker-compose.yml << END
#version: '3.7'
#
#services:
#
#  main:
#    image: ejabberd/ecs:latest
#    environment:
#      - ERLANG_NODE_ARG=ejabberd@main
#      - ERLANG_COOKIE=dummycookie123
#      - CTL_ON_CREATE=register admin localhost password ;
#                      register lukasz localhost password ;
#                      register lambda localhost password
#      - CTL_ON_START=stats registeredusers ;
#                     status
#    extra_hosts:
#      - "main:127.0.0.1"
#      - "replica:10.10.10.10"
#
#END
#
#docker run --name ejabberd -d -p 5222:5222 -p 4369-4399:4369-4399 -p 1883:1883 -p 5269:5269 -p 5280:5280 -p 5443:5443 --init ejabberd/ecs

echo "...MASTER..." > /home/ubuntu/start.log
echo "hostname $(hostname)" >> /home/ubuntu/start.log
echo "pwd $(pwd)" >> /home/ubuntu/start.log
export >> /home/ubuntu/start.log
