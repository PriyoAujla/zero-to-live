#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
APP="yet-another-social-media-app"
sudo docker build -t $APP $SCRIPT_PATH

sudo docker run -v $HOST_PROJECT_PATH/jenkins/home/jobs/$APP/workspace:/app \
           $APP \
           /bin/bash -c "cd $APP; ../gradlew --no-daemon build"