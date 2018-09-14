Zero to Live in Kotlin

Episode 1.0 - "All I wanted to do was build the project but I need to install postgresql, redis, rabbitmq, chromedriver ......"

We have a very minimal project setup at this point.

build.gradle - Has the very basic stuff needed to have a multi module project setup, in particular take notice that we are 
defining the project dependencies in one place using a map collection. ensuring we only use one version of a library and 
don't fall into classpath issues of our own making as well as removing obvious duplication.

yet-another-social-media-app/ directory is a module and the yet-another-social-media-app/src/main/kotlin/com/priyoaujla/app/service.kt is where the main method for a service lives. 
Any module with a service.kt will produce an executable jar file when you run gradle build.

We want a project that you can checkout and run without having to install anything on your local machine (well apart from docker and heroku). 
To achieve this we turn to docker. I won't explain what docker is because the docker website does a good job of that.

We have a Dockerfile under the path yet-another-social-media-app/Dockerfile and this file creates the docker container environment for the module
yet-another-social-media-app. The file looks like this 

```docker
FROM ubuntu:18.04

RUN DEBIAN_FRONTEND=noninteractive apt-get -y update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install software-properties-common
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

WORKDIR /app

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV GRADLE_USER_HOME /app/.gradle
```

The important bits to notice is that we are installing oracle's java 8 runtime and creating a directory /app and setting some environment variables.
The working directory is being set to /app which is where you will run commands from for example.
 
Now that we have our Dockerfile how do we run gradle commands from within docker? we do this by using bash scripts and the following script
is how we are going to check that the module is compiling and all tests are passing. 
The bash script is located in yet-another-social-media-app/check.sh and looks like the following

```bash
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
```
We have variables called SCRIPT_PATH, APP, PARENT_DIR and USER_GRADLE.

*SCRIPT_PATH - path to the script file (in this case check.sh)
*APP - app name
*PARENT_DIR - will refer to the parent directory where the command is being run from
*USER_GRADLE - refers to the .gradle folder in your own user directory, we need this so that we can use our local .gradle and avoid having to download all dependencies from scratch when the container runs gradle check

We first build the docker container using the build command, the build command will take the Dockerfile which resides in the same directory path '$SCRIPT_PATH'.
Then the docker container is run with some flags, the -v flags mount folders on the host machine into the container at the given location. 
This comes in particularly handy for gradle because you don't want to have to download dependencies every time docker container is run, so we mount our local .gradle folder
and take advantage of any already downloaded dependencies.

Our Dockerfile above will always change directory for you to /app which is where zero-to-live has been mounted. The bash command we run first is 'cd $APP' which gets us into the folder yet-another-social-media-app/.
Then running ../gradlew which exists at the project root (zero-to-live) and we run the check gradle command.

To run the gradle command check in docker all we have to do is execute te bash script check.sh.

Episode 1.1 - "It works on my machine"

We need to have a build server, this is important for a multitude of reasons but will only list what I feel to be the most important for this blog series below:

1. Your code will be executed on a consistent environment which itself gives you confidence about the likely hood of the code working against the target environment (However docker largely negates this advantage now)
2. Sometimes you checked in some code that causes a dependency to fail but the immediate module tests all pass..
3. You should never ever deploy a server with mouse clicks and keyboard tapping on some UI interface, our build server is where the code gets pushed from to it's target environment.

The folder jenkins/ has all the files we need run.sh, template-config.xml and Dockerfile.

run.sh looks like the following 

```bash
#!/bin/bash

set -e

PARENT_DIR="$(dirname "$(pwd)")"
find $PARENT_DIR -name Jenkinsfile -exec echo {} \; | grep -v "jenkins/home" | xargs dirname | xargs basename | xargs -I '{}' mkdir -p $PARENT_DIR/jenkins/home/jobs/{}
find $PARENT_DIR -name Jenkinsfile -exec echo {} \; | grep -v "jenkins/home" | xargs dirname | xargs basename | xargs -I '{}' cp $PARENT_DIR/jenkins/template-config.xml $PARENT_DIR/jenkins/home/jobs/{}/config.xml
find $PARENT_DIR -name Jenkinsfile -exec echo {} \; | grep -v "jenkins/home" | xargs dirname | xargs basename | xargs -I '{}' sed -i -e 's/MODULEPATH/{}/g' $PARENT_DIR/jenkins/home/jobs/{}/config.xml

docker build -t local-jenkins .

docker run -p 8080:8080 \
           -p 50000:50000 \
           -v /var/run/docker.sock:/var/run/docker.sock \
           -v $(which docker):/usr/bin/docker \
           -v $PARENT_DIR/jenkins/home:/var/jenkins_home \
           -v $PARENT_DIR/$PROJECT:/job/$PROJECT \
           -e HOST_PROJECT_PATH=$PARENT_DIR \
           -e HEROKU_API_KEY=$HEROKU_API_KEY \
            local-jenkins
```

The file run.sh is similar to check.sh in that it handles the running of docker commands in the correct sequence.

The 3 find commands you see will find all the Jenkinsfile in the project (all modules you want to see in youe CI)
and create a job directory for them, move template-config.xml and then replace MODULEPATH in the template file with the name of the module.

This means we don't have to do any setup with jenkins



 
