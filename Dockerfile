FROM leafgarland/janet-sdk

RUN apk add --no-cache leveldb-dev
COPY project.janet /app/
COPY neil.janet /app/
COPY neil/*.janet /app/neil/
COPY neil/actions/*.janet /app/neil/actions/
COPY psk.key /app/

WORKDIR /app
RUN jpm deps
RUN jpm run createdb

VOLUME /app/scores
EXPOSE 6660

CMD ["jpm", "run", "neil"]
