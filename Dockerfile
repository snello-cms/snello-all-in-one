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
RUN mkdir /ng-app
ADD --from=gitter_web  src  ./ng-app/src
ADD --from=gitter_web  e2e  ./ng-app/e2e
ADD --from=gitter_web *.json ./ng-app/
WORKDIR /ng-app
RUN npm i && $(npm bin)/ng build --prod

### STAGE 4: MAVEN build api project ###
FROM maven:3.5-jdk-8-alpine as builder_api
COPY --from=gitter_api pom.xml /tmp/
COPY --from=gitter_api src /tmp/src
COPY --from=builder_web /ng-app/dist /tmp/src/main/java/resources/
WORKDIR /tmp
RUN mvn package -Dmaven.test.skip=true

FROM openjdk:11.0.1-jre-slim-stretch
ENV SNELLO_HOME=/home/snello \
    SNELLO_USER=snello \
    SNELLO_GROUP=snello \
    SNELLO_PGUID=2000 \
    SNELLO_PUID=2000
RUN useradd -ms /bin/bash snello
COPY --from=MAVEN_TOOL_CHAIN /tmp/target/snello*.jar $SNELLO_HOME/snello.jar
RUN chown -R snello $SNELLO_HOME
WORKDIR ${SNELLO_HOME}
USER ${SNELLO_USER}
RUN mkdir /home/snello/files
CMD java ${JAVA_OPTS} -jar snello.jar
