# snellocms/snello-all-in-one
snello backend and snello api in a docker image

- for developers:
  - docker build -t snellocms/snello-all-in-one . --no-cache

- to run on 8080 port:
  - docker run -p 8080:8080 snellocms/snello-all-in-one

- to open debug port 
  - docker run -p 8080:8080 -e JAVA_OPTS=-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8787  snellocms/snello-all-in-one

- to mount public folder:
  - docker run -p 8080:8080 -v /Users/fiorenzo/IdeaProjectsSnello/snello-all-in-one/public:/home/snello/public/files -e JAVA_OPTS=-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8787  snellocms/snello-all-in-one
