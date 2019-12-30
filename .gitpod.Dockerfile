FROM gitpod/workspace-full-vnc:latest

USER root

# Update apt repositories
RUN apt-get update

# Upgrade the image
RUN apt upgrade -y
RUN apt dist-upgrade -y

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

# Install Markdownlint-cli (https://github.com/igorshubovych/markdownlint-cli)
RUN apt install -y npm
RUN npm install -g markdownlint-cli

## Get linting for Markdown
# Get dependencies
RUN apt install -y golang pandoc
# Compile and install
# USER gitpod
#  RUN GOPATH="/workspace/go" go get github.com/mrtazz/checkmake
#  RUN GOPATH="/workspace/go" make -C "$GOPATH/src/github.com/mrtazz/checkmake"
#  RUN GOPATH="/workspace/go" make -C "$GOPATH/src/github.com/mrtazz/checkmake" install
# USER root

# Remove apt sources to clean up space
RUN rm -rf /var/lib/apt/lists/*

# Clean-up unneeded packages
RUN apt autoremove -y