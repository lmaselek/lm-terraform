#!/bin/bash

sudo apt update -y
#sudo apt upgrade -y
sudo apt install docker.io -y
sudo usermod -aG docker ubuntu
sudo systemctl start docker
sudo systemctl enable docker
echo "${USER}" >>/home/ubuntu/register_users.log
echo "before run ... $(date)" >>/home/ubuntu/register_users.log
sudo docker run -d -t -h mongooseim-1 --name mongooseim-1 -p 5222:5222 mongooseim/mongooseim:latest
echo "mongooseim is running ... $(date)" >>/home/ubuntu/register_users.log

sudo /usr/bin/sleep 10
echo "before register lukasz, admin and lambda ... $(date)" >>/home/ubuntu/register_users.log
sudo docker exec -it mongooseim-1 /usr/lib/mongooseim/bin/mongooseimctl register_identified lukasz localhost password
sudo docker exec -it mongooseim-1 /usr/lib/mongooseim/bin/mongooseimctl register_identified admin localhost password
sudo docker exec -it mongooseim-1 /usr/lib/mongooseim/bin/mongooseimctl register_identified lambda localhost password
echo "after register lukasz, admin and lambda ... $(date)" >>/home/ubuntu/register_users.log
