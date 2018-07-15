# A state-of-the-art Review Board image

A Docker image based on Alpine Linux for running the code review tool
[Review Board](https://www.reviewboard.org).

If you feel something is wrong with it, please let us know on
[GitHub](https://github.com/easybe/alpine-reviewboard/issues)!

## Example

### docker-compose.yml:
```yml
version: '3'
volumes:
  mysql:
  reviewboard:
services:
  mysql:
    container_name: mysql
    image: mysql:5.7
    restart: always
    environment:
      - MYSQL_DATABASE=reviewboard
      - MYSQL_USER=reviewboard
      - MYSQL_PASSWORD
      - MYSQL_ROOT_PASSWORD
    volumes:
      - mysql:/var/lib/mysql
  memcached:
    container_name: memcached
    image: memcached:alpine
    restart: always
  reviewboard:
    container_name: reviewboard
    image: easybe/alpine-reviewboard
    restart: always
    links:
      - mysql:db
      - memcached
    ports:
      - "8080:8000"
    environment:
      - DB_PASSWORD
      - RB_ADMIN_PASSWORD
      - RB_ADMIN_EMAIL
      - UWSGI_PROCESSES
      - VIRTUAL_HOST
    volumes:
      - reviewboard:/var/www
```

### .env:
```sh
MYSQL_ROOT_PASSWORD=p4ssw0rd
MYSQL_PASSWORD=p4ssw0rd
DB_PASSWORD=p4ssw0rd
RB_COMPANY="E Corp"
RB_ADMIN_PASSWORD=p4ssw0rd
RB_ADMIN_EMAIL=admin@e-corp-usa.com
UWSGI_PROCESSES=10
#VIRTUAL_HOST=reviews.e-corp-usa.com
```

### Start the containers:
```sh
$ docker-compose up -d
```

## Environment variables

  * `DB_TYPE`
    * The type of database to be used, `mysql` or `postgresql`
    * Default: `mysql`
  * `DB_PORT`
    * The port for the database
    * Default: `3306`
  * `DB_NAME`
    * The name of the database
    * Default: `reviewboard`
  * `DB_USER`
    * The database user
    * Default: `reviewboard`
  * `DB_PASSWORD`
    * The password associated to the database user
    * Default: `reviewboard`
  * `RB_COMPANY`
    * Your company's name
    * Default: `Example Inc`
  * `RB_ADMIN`
    * The login name for the Review Board admin
    * Default: `admin`
  * `RB_ADMIN_PASSWORD`
    * The password for the Review Board admin
    * Default: `admin`
  * `RB_ADMIN_EMAIL`
    * The e-mail address for the Review Board admin
    * Default: `admin@example.com`
  * `UWSGI_PROCESSES`
    * The number of thread to be used by the web server
    * Default: `10`
  * `VIRTUAL_HOST`
    * The fully qualified domain name for Review Board
    * Default: `*` (insecure!)

# Image for developing Review Board

Running the dev server:

    docker run --rm -v $REVIEWBOARD_SRC:/src -p 8080:8080 \
        easybe/alpine-reviewboard:dev server

Running all tests:

    docker run --rm -v $REVIEWBOARD_SRC:/src easybe/alpine-reviewboard:dev test

Running only certain tests:

    docker run --rm -v $REVIEWBOARD_SRC:/src easybe/alpine-reviewboard:dev test \
        reviewboard.reviews.tests.test_review

Running management commands:

    docker run --rm -v $REVIEWBOARD_SRC:/src easybe/alpine-reviewboard:dev \
        manage --help

Running a shell:

    docker run --rm -v $REVIEWBOARD_SRC:/src easybe/alpine-reviewboard:dev
