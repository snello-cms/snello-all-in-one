### STAGE 1: GIT admin project ###
FROM alpine/git  as gitter_web
WORKDIR /app
RUN git clone https://github.com/snello-cms/snello-admin.git
### STAGE 2: GIT api project ###
FROM alpine/git as gitter_api
WORKDIR /app
RUN git clone https://github.com/snello-cms/snello-api.git
### STAGE 3: NG BUILD web api ###
FROM node:10-alpine as builder_web
RUN mkdir ./ng-app
COPY --from=gitter_web /app/snello-admin/src ./ng-app/src
COPY --from=gitter_web /app/snello-admin/e2e ./ng-app/e2e
COPY --from=gitter_web /app/snello-admin/*.json ./ng-app/
WORKDIR /ng-app
RUN npm i && $(npm bin)/ng build --prod
### STAGE 4: MAVEN build api project ###
FROM maven:3.6.1-jdk-11-slim as builder_api
COPY --from=gitter_api app/snello-api/pom.xml /tmp/
COPY --from=gitter_api app/snello-api/src /tmp/src
COPY --from=builder_web /ng-app/dist /tmp/src/main/resources/admin
COPY  application.yaml /tmp/src/main/resources
WORKDIR /tmp
RUN mvn -version
RUN mvn package -Dmaven.test.skip=true

### STAGE 4: CREATE FINAL DOCKER MACHINE  ###
FROM openjdk:11.0.1-jre-slim-stretch
ENV SNELLO_HOME=/home/snello \
    SNELLO_USER=snello \
    SNELLO_GROUP=snello \
    SNELLO_PGUID=2000 \
    SNELLO_PUID=2000
RUN useradd -ms /bin/bash snello
COPY --from=builder_api /tmp/target/snello*.jar $SNELLO_HOME/snello.jar
RUN chown -R snello $SNELLO_HOME
WORKDIR ${SNELLO_HOME}
USER ${SNELLO_USER}
RUN mkdir /home/snello/files
CMD java ${JAVA_OPTS} -jar snello.jar
