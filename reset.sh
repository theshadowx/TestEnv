#!/bin/bash

export HOST_IP_TEST='192.168.1.50'

vagrant halt test
vagrant destroy test
docker-machine rm test
rm -r .vagrant/ .ssh/
rm -r ~/.vagrant.d/
rm -r ~/.docker
rm ~/.ssh/id_rsa_vagrant*
ssh-keygen -R $HOST_IP_TEST