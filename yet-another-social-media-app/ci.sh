#!/bin/bash

APP="yet-another-social-media-app"
sudo docker build -t $APP .

sudo docker run -v $HOST_PROJECT_PATH/jenkins/home/jobs/$APP/workspace:/app \
           $APP \
           /bin/bash -c "cd $APP; ../gradlew --no-daemon build"