FROM gitpod/workspace-full:latest

# Gitpod is using ubuntu

# Install custom tools, runtime, etc. using apt-get
# For example, the command below would install "bastet" - a command line tetris clone:
#
# RUN apt-get update \
#    && apt-get install -y bastet \
#    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*
#
# More information: https://www.gitpod.io/docs/42_config_docker/

USER root

# Install dependencies
RUN apt-get update && apt-get install -y meson cppcheck libcap-dev clang libfuse3-dev gcc git ninja-build bison libtool autoconf pkg-config libcap-dev indent fakeroot libattr1-dev uthash-dev gzip rsync autopoint uthash-dev shellcheck
# Install shfmt (Hack!)
RUN wget https://github.com/mvdan/sh/releases/download/v3.0.0-beta1/shfmt_v3.0.0-beta1_linux_amd64 -O /usr/bin/shfmt && chmod +x /usr/bin/shfmt

# Give back control
USER root
