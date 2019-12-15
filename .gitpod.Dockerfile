FROM paludis/exherbo-gcc:latest

USER root

RUN cave sync

RUN cave resolve shellcheck -x