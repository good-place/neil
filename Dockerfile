FROM leafgarland/janet-sdk

RUN apk add --no-cache leveldb-dev
COPY project.janet /app/
COPY neil.janet /app/
COPY hydrpc.janet /app/
COPY neil/tell.janet /app/neil/
COPY neil/actions/ /app/neil/actions/
COPY psk.key /app/

RUN mkdir /app/scores
VOLUME /app/scores
EXPOSE 6660

WORKDIR /app
RUN jpm deps

CMD ["jpm", "run", "neil"]
