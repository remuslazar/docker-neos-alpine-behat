Docker Neos Testing
===================

Abstract
--------

This is basically an add-on to the [Docker Neos Alpine](https://hub.docker.com/r/remuslazar/docker-neos-alpine/) image adding support
for Behat Tests.

Because this image uses all the feature from the base image, refer to the documentation
of the base image for details.

This image will not run the web-server not php-fpm, so all configurations related
to this services are obsolete in this context.

Important Note
--------------

** Currently this project is in a WIP state, not fully functional or useful. **

Required Configuration
---

Make sure you use the `--dev` composer install option, to install also development
packages like behat. The base package should also automatically call
`./flow behat:setup` for you, in case you can run this steps manually:

```bash
composer install --dev
./flow flow:cache:flush
./flow behat:setup
```

This will setup everything needed to run behat.

Docker Compose
--------------

Use this container with docker-compose. E.g. to add a test DB instance and also
this container use this setup:

FILE `docker-compose.behat.yml`

```
version: '3.1'

services:
  behat-runner:
    image: remuslazar/neos-alpine-behat:php56
    hostname: daz-docker-behat
    ports:
    - '1123:22'
    - '5900:5900'
    links:
    - web
    - db-test
    - elasticsearch
    volumes:
    - data:/data
    environment:
      IMPORT_GITHUB_PUB_KEYS: 'remuslazar'

  db-test:
    image: mariadb:latest
    expose:
    - 3306
    volumes:
    - /var/lib/data
    environment:
      MYSQL_DATABASE: 'db'
      MYSQL_USER: 'admin'
      MYSQL_PASSWORD: 'pass'
      MYSQL_RANDOM_ROOT_PASSWORD: 'yes'

  web:
    environment:
      DB_TEST_HOST: db-test
    links:
      - db-test
```

To call this add-on, just use:

```bash
docker-compose -f docker-compose.yml -f docker-compose.behat.yml up -d
```

This will bring up the whole stack. The Behat will re-use the `web` container of
your NEOS project. Make sure to also add the `data` volume.

Usage
-----

SSH into the `behat-runner`:

```bash
ssh -p1123 www-data@$(docker-machine ip my-dev-machine-name)
```

There you can run your Behat Tests, e.g. using:

```
cd ~/www/Packages/Sites/CRON.DazSite/Tests/Behavior
~/www/bin/behat --ansi -c behat.yml Features/DemoContent.feature
```

----

How to build
------------

```bash
docker build -t remuslazar/neos-alpine-behat:php56 .
```
