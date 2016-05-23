#!/bin/bash

export HOST_IP_TEST='192.168.1.50'

echo "--------->  ENV -----------------------------"
# # We can leverage the power of Docker Compose and a local registry to fasten our development of Docker images.
# # activate your development Docker Machine:
 eval "$(docker-machine env test)"

 echo "--------->  registry -----------------------------"
# # Now, we will use the development Docker Machine as our local registry:
ssh root@$HOST_IP_TEST "mkdir -p /var/lib/registry"
docker-compose -f ./docker/registry.yml build

# For making it visible to our preproduction VM, we need to update our default firewall rules:
ssh root@$HOST_IP_TEST ufw allow 5000

echo "--------->  Docker Engine -----------------------------"
ssh root@$HOST_IP_TEST 'echo \"$(cat /etc/default/docker) --insecure-registry 192.168.1.50:5000\" > /etc/default/docker'

echo "--------->  restart -----------------------------"
# #We need to restart our Docker daemon and restart the Docker registry on the development VM:
ssh root@$HOST_IP_TEST systemctl restart docker


echo "--------->  Building Mongo -----------------------------"

# prepare the volume on each host that receives and persists Mongo's data
ssh root@$HOST_IP_TEST "rm -rf /var/db; mkdir -p /data/db; chmod go+w /data/db"

# building our Mongo Docker image:
docker-compose -f ./docker/docker-compose.yml build db

echo "--------->  Building Meteor -----------------------------"

ssh root@$HOST_IP_TEST "mkdir -p /etc/meteor"

# copy your settings.json files on each hosts using a regular SCP. Mine are slightly different depending on the target where I deploy my Meteor apps.
# scp ../app/test.json root@$HOST_IP_TEST:/etc/meteor/settings.json

docker-compose -f ./docker/docker-compose.yml build server 

echo "--------->  Building Qt+Android -----------------------------"

docker-compose -f ./docker/docker-compose.yml build front