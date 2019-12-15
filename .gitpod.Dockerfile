FROM exherbo/exherbo_ci:latest

USER root

RUN cave sync

RUN cave resolve xlogo -x
