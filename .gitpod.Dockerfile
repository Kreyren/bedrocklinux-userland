FROM paludis/exherbo-gcc:next

RUN cave sync

RUN cave resolve xlogo -x
