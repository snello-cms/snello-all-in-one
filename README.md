# snellocms/snello-all-in-one
Snello backend and snello api in a single docker image. 

**Enjoy fast! enjoy SNELLO!**

- **to run on 8080 port:**
  - docker run -t -i -p 8080:8080 snellocms/snello-all-in-one
  - open the browser in: http://localhost:8080/snello-admin (using username: admin - password: admin)

- **for developers (git clone, build and run):**
  - git clone https://github.com/snello-cms/snello-all-in-one.git
  - cd  snello-all-in-one
  - docker build --no-cache -t snellocms/snello-all-in-one .

- **to open debug port:**
  - docker run -t -i -p 8080:8080 -e JAVA_OPTS=-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8787  snellocms/snello-all-in-one

- **to mount public folder:**
  - docker run -t -i -p 8080:8080 -v /Users/fiorenzo/IdeaProjectsSnello/snello-all-in-one/public:/home/snello/public/files -e JAVA_OPTS=-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8787  snellocms/snello-all-in-one

- **to query h2 database using a client (like DBeaver):**
  - docker run -t -i -p 8080:8080 -v /Users/fiorenzo/IdeaProjectsSnello/snello-all-in-one/db/home/snello/db -e JAVA_OPTS=-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8787  snellocms/snello-all-in-one
  - in dbeaver: use 
     - Database/Schema: /Users/fiorenzo/IdeaProjectsSnello/snello-all-in-one/db/repository;MODE=MySQL;IGNORECASE=TRUE;DATABASE_TO_LOWER=TRUE;CASE_INSENSITIVE_IDENTIFIERS=TRUE
     - Username: sa
     - Password: ''    
