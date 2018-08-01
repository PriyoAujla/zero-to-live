#!/bin/bash

APP="yet-another-social-media-app"

docker run -v /var/run/docker.sock:/var/run/docker.sock \
           -v $(which docker):$(which docker) \
           -v $PARENT_DIR:/app \
           -v $USER_GRADLE:/root/.gradle \
           $APP \
           /bin/bash -c "cd $APP; ../gradlew --no-daemon build"