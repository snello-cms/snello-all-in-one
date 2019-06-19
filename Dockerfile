### STAGE 1: GIT CLONE admin project AND api project ###
FROM alpine/git  as gitter
WORKDIR /app
RUN git clone https://github.com/snello-cms/snello-admin.git
RUN git clone https://github.com/snello-cms/snello-api.git

### STAGE 3: ANGULAR BUILD web api, OVERRIDING THE BASE PATH IN THE INDEX PAGE ###
FROM node:10-alpine as builder_web
RUN mkdir ./ng-app
COPY --from=gitter /app/snello-admin/src ./ng-app/src
COPY --from=gitter /app/snello-admin/e2e ./ng-app/e2e
COPY --from=gitter /app/snello-admin/*.json ./ng-app/
COPY  override/snello-admin/index.html ./ng-app/src
WORKDIR /ng-app
RUN npm i && $(npm bin)/ng build --prod

### STAGE 4: MAVEN build api project, OVERRIDING application.yaml file ###
FROM maven:3.6.1-jdk-11-slim as builder_api
COPY --from=gitter /app/snello-api/pom.xml /tmp/
COPY --from=gitter /app/snello-api/src /tmp/src
COPY --from=builder_web /ng-app/dist /tmp/src/main/resources
COPY  override/snello-api/application.yaml /tmp/src/main/resources
WORKDIR /tmp
RUN mvn package -Dmaven.test.skip=true

### STAGE 4: CREATE FINAL DOCKER MACHINE ADDING PUBLIC INDEX PAGE ###
FROM adoptopenjdk/openjdk11:alpine-jre
ENV SNELLO_HOME=/home/snello \
    SNELLO_USER=snello \
    SNELLO_GROUP=snello \
    SNELLO_PGUID=1000 \
    SNELLO_PUID=1000

RUN apk add --no-cache tzdata \
 && cp /usr/share/zoneinfo/Europe/Rome /etc/localtime \
 && addgroup -g ${SNELLO_PGUID} -S ${SNELLO_GROUP} \
 && adduser -h ${SNELLO_HOME} -s /sbin/nologin -G ${SNELLO_GROUP} -S -D -u ${SNELLO_PUID} ${SNELLO_USER}


RUN mkdir -p /home/snello/public/files
RUN mkdir -p /home/snello/db
COPY  override/public/index.html /home/snello/public/
COPY --from=builder_api /tmp/target/snello*.jar $SNELLO_HOME/snello.jar

RUN chown -R ${SNELLO_USER}:${SNELLO_GROUP} ${SNELLO_HOME}
RUN chmod -R 755 ${SNELLO_HOME}

WORKDIR ${SNELLO_HOME}
USER ${SNELLO_USER}
# update ownership
CMD java ${JAVA_OPTS} -jar snello.jar
