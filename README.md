# Review Board

A [Review Board](https://www.reviewboard.org) Docker image based on Alpine Linux.

This images work with:
* MySQL or PostgreSQL as a database
* Subversion and Git SCM
* Memcached for the cache server

## How to run it

```
cp .env.tpl .env
$EDITOR .env
docker-compose up -d
```

## Configuration variables

You can configure this images with some environment variables:

* `DB_TYPE`
    * The database server you want to use. `mysql` or `postgresql`
    * Default value: `mysql`
* `DB_PORT`
    * The port of database you want to use.
    * Default value: `3306`
* `DB_NAME`
    * The database name you want to use
    * Default value: `reviewboard`
* `DB_USER`
    * The database user you want to use
    * Default value: `reviewboard`
* `DB_PASSWORD`
    * The password associated to your database user
    * Default value: `reviewboard`
* `RB_COMPANY`
    * Your company's name
    * Default value: `Example Inc`
* `RB_ADMIN`
    * The login admin for the Review Board instance
    * Default value: `admin`
* `RB_PASSWORD`
    * The password of Review Board admin
    * Default value: `admin`
* `RB_ADMIN_EMAIL`
    * The email of Review Board admin
    * Default value: `admin@example.com`
* `UWSGI_PROCESSES`
    * The number of thread use by the web server
    * Default value: `10`
