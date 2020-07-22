FROM leafgarland/janet-sdk
RUN apk add --no-cache leveldb-dev
COPY *.janet /root/
COPY neil/tell.janet /root/neil/
COPY neil/actions/* /root/neil/actions/
COPY psk.key /root

RUN mkdir /root/scores
VOLUME /root/scores
EXPOSE 6660

WORKDIR /root
RUN jpm deps
RUN jpm build

CMD ["jpm", "run", "neil"]
