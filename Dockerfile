FROM openjdk:11.0.1-jre-slim-stretch

ENV SNELLO_HOME=/home/snello \
    SNELLO_USER=snello \
    SNELLO_GROUP=snello \
    SNELLO_PGUID=2000 \
    SNELLO_PUID=2000
RUN useradd -ms /bin/bash snello
COPY snello-api*.jar $SNELLO_HOME/snello-api.jar
ADD snello-admin/ $SNELLO_HOME/webroot/
RUN chown -R snello $SNELLO_HOME
WORKDIR ${SNELLO_HOME}
USER ${SNELLO_USER}

CMD java ${JAVA_OPTS} -jar snello-api.jar


HEALTHCHECK --interval=1m --timeout=3s CMD wget --quiet --tries=1 --spider http://localhost:8080/health || exit