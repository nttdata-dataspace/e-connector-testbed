FROM eclipse-temurin:17-jre-alpine

RUN apk add --no-cache curl bash
SHELL ["/bin/bash", "-c"]

RUN adduser -D -H -s /sbin/nologin edc
USER edc:edc

WORKDIR /app
COPY ./build/libs/connector.jar /app
COPY ./.env /app/.env
RUN touch /app/empty.properties

# This allows env vars in .env to be set as default values and overridden by docker-compose.
RUN sed -ri 's/^\s*(\S+)=(.*)$/\1=${\1:-"\2"}/' .env

ENV JVM_ARGS=""
ENTRYPOINT set -a && source /app/.env && set +a && set && exec java $JVM_ARGS -jar connector.jar
