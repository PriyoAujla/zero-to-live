Zero to Live in Kotlin

Episode 1.0 - "All I wanted to do was build the project but I need to install postgresql, redis, rabbitmq, chromedriver ......"

We have a very minimal project setup at this point.

build.gradle - Has the very basic stuff needed to have a multi module project setup in particular notice that we are 
defining the project dependencies in one place using a map collection. ensuring we only use one version of a library and 
don't fall into classpath issues of our own making as well as removing obvious duplication.

service.kt - This is the entry point for a webapp, any module with a service.kt will produce an executable jar file when you run gradle build.

We want a project that you can checkout and run without having to install anything on your local machine (well apart from one thing ;)). 
To achieve this we turn to docker. I won't explain what docker is because the docker website does a good job of that, 
I will however cast you gaze to the following file check.sh

```bash
#!/bin/bash

APP="yet-another-social-media-app"
docker build -t $APP .

PARENT_DIR="$(dirname "$(pwd)")"
USER_GRADLE=~/.gradle
docker run -v $PARENT_DIR:/app \
           -v $USER_GRADLE:/root/.gradle \
           $APP \
           /bin/bash -c "cd $APP; ../gradlew --no-daemon check"
```
We have a variable called APP, PARENT_DIR and USER_GRADLE. 
*APP is self explanatory 
*PARENT_DIR will refer to the parent directory where the command is being run from and the directory we will mount into the container so it can have access to the project files
*USER_GRADLE refers to the .gradle folder in your own user directory, we need this so that we can use our local .gradle and avoid having to download all dependencies from scratch when the container runs gradlew check

The command being run is a cd to the module directory and then running ./gradlew which exists at the root of the project folder.

To run the gradle command check in docker all we have to do is execute te bash script check.sh

We also have our Dockerfile next to check.sh and this ensures we get a container that can run the gradle check command, so it has for example Java 8 installed.

Episode 1.1 - "But it built on my machine"

We need to have a build server, this is important for a multitude of reasons but will only list what I feel to be the most important for this blog series below:

1. Your code will be executed on a consistent environment which itself gives you confidence about the likely hood of the code working against the target environment (However docker largely negates this advantage now)
2. Sometimes you couldn't be bothered to do a whole build and checked in some dodgy bit of code that fails a test.
3. You should never ever deploy a server with mouse clicks and keyboard tapping on some UI interface, our build server is where the code gets pushed from to it's target environment. 
