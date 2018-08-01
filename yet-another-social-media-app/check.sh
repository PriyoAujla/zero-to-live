#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
APP="yet-another-social-media-app"
docker build -t $APP $SCRIPT_PATH

PARENT_DIR="$(dirname "$(pwd)")"
USER_GRADLE=~/.gradle
docker run -v $PARENT_DIR:/app \
           -v $USER_GRADLE:/root/.gradle \
           $APP \
           /bin/bash -c "cd $APP; ../gradlew --no-daemon check"