FROM gitpod/workspace-full:latest

USER root

# Update apt repositories
RUN apt-get update

# Install dependencies
RUN apt-get install -y meson cppcheck libcap-dev clang libfuse3-dev gcc git ninja-build bison libtool autoconf pkg-config libcap-dev indent fakeroot libattr1-dev uthash-dev gzip rsync autopoint uthash-dev shellcheck 

# Install shfmt (Hack!)
## Fetch Latest stable version of shfmt using github API
ENV shfmt_version="$(curl https://api.github.com/repos/mvdan/sh/releases/latest 2>/dev/null | grep -w tag_name | sed -E 's@\s+\"tag_name\":\s\"v([^\"]+)\",@\1@gm')"

RUN echo "${shfmt_version}"

## Import shfmt on the system
RUN [ ! -e /usr/bin/shfmt ] && { wget "https://github.com/mvdan/sh/releases/download/v${shfmt_version}/shfmt_v${shfmt_version}_linux_amd64" -O /usr/bin/shfmt || printf 'ERROR: %s\n' "Unable to import shfmt using hack" ;} || printf 'INFO: %s\n' "shfmt is already installed, skipping hack.."

## Make sure that shfmt is executable
RUN [ ! -x /usr/bin/shfmt ] && chmod +x /usr/bin/shfmt