#!/bin/bash

set -e

PARENT_DIR="$(dirname "$(pwd)")"
find $PARENT_DIR -name Jenkinsfile -exec echo {} \; | grep -v "jenkins/home" | xargs dirname | xargs basename | xargs -I '{}' mkdir -p $PARENT_DIR/jenkins/home/jobs/{}
find $PARENT_DIR -name Jenkinsfile -exec echo {} \; | grep -v "jenkins/home" | xargs dirname | xargs basename | xargs -I '{}' cp $PARENT_DIR/jenkins/template-config.xml $PARENT_DIR/jenkins/home/jobs/{}/config.xml
find $PARENT_DIR -name Jenkinsfile -exec echo {} \; | grep -v "jenkins/home" | xargs dirname | xargs basename | xargs -I '{}' sed -i -e 's/MODULEPATH/{}/g' $PARENT_DIR/jenkins/home/jobs/{}/config.xml

docker pull jenkins/jenkins:lts

docker run -p 8080:8080 \
           -p 50000:50000 \
           -v $PARENT_DIR/jenkins/home:/var/jenkins_home \
           -v $PARENT_DIR/$PROJECT:/job/$PROJECT \
            jenkins