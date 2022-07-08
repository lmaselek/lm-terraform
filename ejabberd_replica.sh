#!/bin/bash

instance_target_host=
source /opt/server_ip

sudo apt update -y
sudo apt install docker.io ngrep -y
sudo usermod -aG docker ubuntu
sudo systemctl start docker
sudo systemctl enable docker

sudo docker run --name ejabberd -d \
  -p 1883:1883 \
  -p 5222:5222 \
  -p 5269:5269 \
  -p 5280:5280 \
  -p 4369-4399:4369-4399 \
  -p 5443:5443 \
  -e ERLANG_NODE_ARG=ejabberd@$(hostname) \
  -e ERLANG_COOKIE=dummycookie123 \
  -e CTL_ON_CREATE="join_cluster ejabberd@$(echo $instance_target_host | cut -d. -f1)" ejabberd/ecs

#sudo docker exec ejabberd bin/ejabberdctl

echo "...REPLICA..." > /home/ubuntu/start.log
echo "Server IP: $instance_target_host" >> /home/ubuntu/start.log
echo "hostname $(hostname)" >> /home/ubuntu/start.log
echo "pwd $(pwd)" >> /home/ubuntu/start.log
export >> /home/ubuntu/start.log

