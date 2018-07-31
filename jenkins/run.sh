#!/bin/bash

PARENT_DIR="$(dirname "$(pwd)")"

docker pull jenkins/jenkins:lts

docker run -p 8080:8080 \
           -p 50000:50000 \
           -v $PARENT_DIR/jenkins/home:/var/jenkins_home \
            jenkins