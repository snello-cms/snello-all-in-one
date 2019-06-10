# snello-all-in-one
snello backend and snello api in a docker image



docker build -t snello/snello-all-in-one . --no-cache

- to run 8080 port:
  - docker run -p 8080:8080 snello/snello-all-in-one

- to run in debug mode, using 8787 port:
  - docker run -p 8080:8080 -e JAVA_OPTS=-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8787  snello/snello-all-in-one

- to mount public folder, using volumes:
  - docker run -p 8080:8080 -v /Users/fiorenzo/IdeaProjectsSnello/snello-all-in-one/public:/home/snello/public/files -e JAVA_OPTS=-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8787  snello/snello-all-in-one 

- to query the h2 database, using volumes:
  - docker run -p 8080:8080 -v /Users/fiorenzo/IdeaProjectsSnello/snello-all-in-one/db:/home/snello/db -e JAVA_OPTS=-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8787  snello/snello-all-in-one 
  - after that you can use JDBC url: jdbc:h2:/Users/fiorenzo/IdeaProjectsSnello/snello-all-in-one/prova/db/repository;MODE=MySQL
