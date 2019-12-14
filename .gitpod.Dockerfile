FROM gitpod/workspace-full:latest

USER root

# Update apt repositories
RUN apt-get update

# Install dependencies
RUN apt-get install -y meson cppcheck libcap-dev clang libfuse3-dev gcc git ninja-build bison libtool autoconf pkg-config libcap-dev indent fakeroot libattr1-dev uthash-dev gzip rsync autopoint uthash-dev shellcheck 

# Install shfmt using brew since it's not yet exported for apt
RUN brew install shfmt