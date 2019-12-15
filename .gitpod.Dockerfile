FROM paludis/exherbo-gcc:latest

RUN cave sync

RUN cave resolve shellcheck -x
