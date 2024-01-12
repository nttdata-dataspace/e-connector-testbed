FROM eclipse-temurin:17-jre-alpine

RUN apk add --no-cache curl bash
SHELL ["/bin/bash", "-c"]

RUN adduser -D -H -s /sbin/nologin edc
USER edc:edc

WORKDIR /app
COPY ./build/libs/connector.jar /app
COPY ./.env /app/.env
COPY ./.env_postgresql /app/.env_postgresql
COPY ./.env_datasource /app/.env_datasource
RUN touch /app/empty.properties

# This allows env vars in .env to be set as default values and overridden by docker-compose.
RUN sed -ri 's/^\s*(\S+)=(.*)$/\1=${\1:-"\2"}/' .env
RUN sed -r  's/^\s*(\S+)=(.*)$/\1=${\1:-"\2"}/' .env_postgresql >> .env
RUN sed -r  's/^\s*(\S+)=(.*)$/\1=${\1:-"\2"}/' .env_datasource >> .env

ENV JVM_ARGS=""
ENTRYPOINT set -a && source /app/.env && set +a && printenv|sort && exec java $JVM_ARGS -jar connector.jar
