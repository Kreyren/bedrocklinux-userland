FROM gitpod/workspace-full-vnc:latest

USER root

# Update apt repositories
RUN apt-get update

# Upgrade the image
RUN apt -y upgrade && apt -y dist-upgrade

# Install build dependencies
RUN apt install -y meson clang gcc git ninja-build bison autoconf fakeroot libcap-dev libfuse3-dev libtool pkg-config libcap-dev libattr1-dev uthash-dev gzip rsync autopoint uthash-dev

# Install test dependencies
RUN apt install -y cppcheck indent shellcheck 

# Install QEMU and it's deps 
RUN apt install -y --install-recommends qemu-kvm qemu virt-manager

# Install vmdb2 to get debian image
RUN apt install -y vmdb2

# Install shfmt using brew since it's not yet exported for apt
RUN brew install shfmt

# Install Markdownlint (https://github.com/DavidAnson/markdownlint)
RUN npm install markdownlint --save-dev

# Remove apt sources to clean up space
RUN rm -rf /var/lib/apt/lists/*

# Clean-up unneeded packages
RUN apt autoremove -y
