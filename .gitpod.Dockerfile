FROM exherbo/exherbo_ci:latest

USER root

# Add required repositories
RUN cave resolve -x1 repository/{alip,compnerd,virtualization,danyspin97,python,perl,hasufell}

# Sync repos
RUN cave sync

# Install dependencies
RUN cave resolve sys-devel/meson dev-util/cppcheck sys-devel/clang sys-fs/fuse dev-scm/git sys-devel/ninja sys-devel/bison sys-devel/libtool sys-devel/autoconf dev-util/pkg-config dev-util/indent sys-apps/fakeroot app-arch/gzip net-misc/rsync sys-devel/autoconf dev-util/shellcheck -x
