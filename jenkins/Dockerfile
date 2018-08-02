FROM jenkins:2.60.3

USER root

RUN apt-get update \
      && apt-get install -y sudo \
      && rm -rf /var/lib/apt/lists/*
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

RUN wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

RUN heroku plugins:install heroku-cli-deploy

USER jenkins