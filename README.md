A [Review Board](https://www.reviewboard.org) Docker image based on Alpine Linux.

Works with:

  * MySQL or PostgreSQL as a database
  * Subversion and Git SCM
  * Memcached for the cache server

If you feel something is missing, please let us know on
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
    * The database server you want to use, `mysql` or `postgresql`
    * Default: `mysql`
  * `DB_PORT`
    * The port of database you want to use
    * Default: `3306`
  * `DB_NAME`
    * The database name you want to use
    * Default: `reviewboard`
  * `DB_USER`
    * The database user you want to use
    * Default: `reviewboard`
  * `DB_PASSWORD`
    * The password associated to your database user
    * Default: `reviewboard`
  * `RB_COMPANY`
    * Your company's name
    * Default: `Example Inc`
  * `RB_ADMIN`
    * The login admin for the Review Board instance
    * Default: `admin`
  * `RB_ADMIN_PASSWORD`
    * The password of Review Board admin
    * Default: `admin`
  * `RB_ADMIN_EMAIL`
    * The email of Review Board admin
    * Default: `admin@example.com`
  * `UWSGI_PROCESSES`
    * The number of thread use by the web server
    * Default: `10`
  * `VIRTUAL_HOST`
    * The FQDN for Review Board
    * Default: `*` (insecure!)
