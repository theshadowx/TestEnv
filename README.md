# TestEnv
Test Environment using Docker &amp; Vagrant for Qt/QML app using Meteor/MongoDB

## Structure

The structure of the test environment is as the following :

![docker vagrant test environment](https://cloud.githubusercontent.com/assets/976569/15440396/2099d5d8-1ecd-11e6-83a9-ab66ca758d8f.png)

## Requirements
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [Vagrant](https://www.vagrantup.com/downloads.html)
- [Docker Engine](https://docs.docker.com/engine/installation/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Docker Machine](https://docs.docker.com/machine/install-machine/)

## Setup the environment

This repository contains two branches:
- [Master](https://github.com/theshadowx/TestEnv/tree/master) : Docker images are built from Dockerfile
- [FromHub](https://github.com/theshadowx/TestEnv/tree/FromHub): Docker images are pulled from [Docker Hub](https://hub.docker.com/r/theshadowx/testenv/)

To setup the environment, use the [configure.sh](https://github.com/theshadowx/TestEnv/blob/master/configure.sh) file :

```
$ cd /path/to/TestEnv
$ chmod +x configure.sh
$ chmod +x config_test.sh
$ ./configure.sh
```

When the configuration finishes, you'll have something that looks like the following:

```
$ eval "$(docker-machine env test)"
$ docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
docker_front        latest              b16d48d8be87        2 days ago          3.931 GB
docker_server       latest              eca845e2c254        2 days ago          1.184 GB
docker_db           latest              1216f4ad159b        2 days ago          311.7 MB
registry            2                   34bccec54793        4 days ago          171.2 MB
debian              jessie              bb5d89f9b6cb        2 weeks ago         125.1 MB
```

## How to use this environment

Let's say you have a Qt/QML app that uses Meteor/MongoDB.
To use your app in this environment:
- The client files should be put in ```/path/to/TestEnv/app/```
- The server files should be put in ```/path/to/TestEnv/app/server/```

```
$ cd /path/to/TestEnv
$ vagrant up
$ eval "$(docker-machine env test)"
$ docker-compose -f ./docker/docker-compose.yml up -d db
```

Wait till the db starts

```
$ docker-compose -f ./docker/docker-compose.yml run --rm db mongo db:27017/admin --quiet --eval "rs.initiate(); rs.conf();"
$ docker-compose -f ./docker/docker-compose.yml up -d server 
```
Wait till the server is up

Now it's time to compile the app, keep in mind that a variable environment **METEOR_URL** is available, in the front container, containing the ip:port of the the meteor server, so that you can link the meteor server to your app
```
$ docker-compose -f ./docker/docker-compose.yml run --rm  front
```
The output of the app compilation will be in ```/path/to/TestEnv/app/build```

To know what hapenning in the containers (db & server)

```
$ docker-compose -f ./docker/docker-compose.yml logs
```

To Shut down the virtual machine containing the test environment
```
$ vagrant halt test
```

## Troubleshooting
While pulling one of the images, you might get :
```
ERROR: Get https://registry-1.docker.io/v2/theshadowx/testenv/manifests/meteor: Get https://auth.docker.io/token?account=theshadowx&scope=repository%3Atheshadowx%2Ftestenv%3Apull&service=registry.docker.io: dial tcp: lookup auth.docker.io on 10.0.2.3:53: no such host

```

The solution for this issue is to restart the docker machine:
```
$ docker-machine restart test && eval "$(docker-machine env test)"
```

Then pull the image that was not pulled
```
$ docker-compose -f ./docker/docker-compose.yml pull #db, server or front
```

## Aknowledgement

The setting of this test environment was inspired from the [devops-tuts](https://github.com/PEM--/devops-tuts)