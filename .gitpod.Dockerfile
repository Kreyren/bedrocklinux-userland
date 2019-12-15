FROM exherbo/exherbo_ci:latest

USER root

# Export paludis-config
RUN rm -r /etc/paludis && git clone https://github.com/Kreyrock/paludis-config.git /etc/paludis

# Sync repos
RUN cave sync

# Add required repositories
RUN cave resolve -x1 repository/alip
RUN cave resolve -x1 repository/compnerd
RUN cave resolve -x1 repository/virtualization
RUN cave resolve -x1 repository/danyspin97
RUN cave resolve -x1 repository/python
RUN cave resolve -x1 repository/perl
RUN cave resolve -x1 repository/hasufell

# Install build dependencies
RUN cave resolve sys-devel/meson sys-devel/clang sys-fs/fuse dev-scm/git sys-devel/ninja sys-devel/bison sys-devel/libtool sys-devel/autoconf dev-util/pkg-config sys-apps/fakeroot app-arch/gzip net-misc/rsync sys-devel/autoconf -x

# Install test dependencies
RUN cave resolve  dev-util/cppcheck  dev-util/indent  dev-util/shellcheck -x

# Purge unwanted packages
RUN cave purge -x

# Remove build instructions
RUN rm -r /var/db/paludis
