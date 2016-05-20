#!/bin/bash

vagrant box add ubuntu/wily64

vagrant up --no-provision

export HOST_IP_TEST='192.168.1.50'

# dev
echo "--------->  create dev machine -----------------------------"
docker-machine -D create -d generic \
  --generic-ip-address $HOST_IP_TEST \
  --generic-ssh-user vagrant \
  --generic-ssh-key ~/.vagrant.d/insecure_private_key \
  test

echo "--------->  Provision -----------------------------"
vagrant provision

echo "--------->  Posts Provision -----------------------------"
ssh-keyscan $HOST_IP_TEST >> ~/.ssh/known_hosts
ssh -i ~/.vagrant.d/insecure_private_key vagrant@$HOST_IP_TEST "bash -s" < ./postProvisioning.sh

 echo "--------->  public key -----------------------------"
# generate public/private key
# copy public key to the machines
mkdir $(pwd)/.ssh
echo "$HOME/.ssh/id_rsa_vagrant" | ssh-keygen -t rsa -P "" -f $(< /dev/stdin)
cp $HOME/.ssh/id_rsa_vagrant.pub $(pwd)/.ssh
ssh -i ~/.vagrant.d/insecure_private_key vagrant@$HOST_IP_TEST "sudo cp /vagrant/.ssh/id_rsa_vagrant.pub /root/.ssh/authorized_keys"

./config_test.sh