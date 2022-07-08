#!/bin/bash

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
  -e CTL_ON_CREATE='register admin localhost password ;
                    register lukasz localhost password ;
                    register lambda localhost password' ejabberd/ecs

# change starttls_required: true -> false
sudo docker cp ejabberd:/home/ejabberd/conf/ejabberd.yml .
sudo sed -i -e 's/starttls_required: true/starttls_required: false/g' ejabberd.yml
sudo docker cp ejabberd.yml ejabberd:/home/ejabberd/conf/ejabberd.yml

sudo docker stop ejabberd
sudo docker start ejabberd

# create MUC
sudo docker exec -it ejabberd bin/ejabberdctl create_room private conference.localhost localhost
sudo docker exec -it ejabberd bin/ejabberdctl change_room_option private conference.localhost persistent true
sudo docker exec -it ejabberd bin/ejabberdctl change_room_option private conference.localhost members_only true
sudo docker exec -it ejabberd bin/ejabberdctl set_room_affiliation private conference.localhost lukasz@localhost member
sudo docker exec -it ejabberd bin/ejabberdctl set_room_affiliation private conference.localhost lambda@localhost member
sudo docker exec -it ejabberd bin/ejabberdctl get_room_affiliation private conference.localhost admin@localhost owner

sudo ngrep port 5222 | tee /home/ubuntu/ngrep_5222.log &

echo "...GENERIC..." > /home/ubuntu/start.log
echo "hostname $(hostname)" >> /home/ubuntu/start.log
echo "pwd $(pwd)" >> /home/ubuntu/start.log
export >> /home/ubuntu/start.log
