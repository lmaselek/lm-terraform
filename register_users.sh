#!/bin/bash

HOST1=$(terraform output -raw instance_public_dns)

ssh -i "../lm-kp.pem" "ubuntu@${HOST1}" sudo docker exec -i mongooseim-1 /usr/lib/mongooseim/bin/mongooseimctl register_identified lukasz localhost password
ssh -i "../lm-kp.pem" "ubuntu@${HOST1}" sudo docker exec -i mongooseim-1 /usr/lib/mongooseim/bin/mongooseimctl register_identified admin localhost password
ssh -i "../lm-kp.pem" "ubuntu@${HOST1}" sudo docker exec -i mongooseim-1 /usr/lib/mongooseim/bin/mongooseimctl register_identified lambda localhost password

HOST2=$(terraform output -raw instance_public_dns_2)

ssh -i "../lm-kp.pem" "ubuntu@${HOST2}" sudo docker exec -i mongooseim-1 /usr/lib/mongooseim/bin/mongooseimctl register_identified lukasz localhost password
ssh -i "../lm-kp.pem" "ubuntu@${HOST2}" sudo docker exec -i mongooseim-1 /usr/lib/mongooseim/bin/mongooseimctl register_identified admin localhost password
ssh -i "../lm-kp.pem" "ubuntu@${HOST2}" sudo docker exec -i mongooseim-1 /usr/lib/mongooseim/bin/mongooseimctl register_identified lambda localhost password
