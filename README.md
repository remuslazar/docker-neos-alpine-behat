Docker Neos Testing
===================

Abstract
--------

This is basically an add-on to the [Docker Neos Alpine](https://hub.docker.com/r/remuslazar/docker-neos-alpine/) image adding support
for Behat Tests.

Because this image uses all the feature from the base image, refer to the documentation
of the base image for details.

Important Note
--------------

** Currently this project is in a WIP state, not fully functional or useful. **

Docker Compose
--------------

Use this container with docker-compose.

As an example, a Neos project with a elasticsearch, your docker-compose could look something like this:

FILE `docker-compose.behat-runner.yml`

```
version: '3.1'

services:
  behat-runner:
    image: remuslazar/neos-alpine-behat:testing
    hostname: behat-runner
    ports:
      - '1122:22'
      - '5900:5900'
    links:
      - db-test
      - elasticsearch
    volumes:
      - data:/data
    environment:
      IMPORT_GITHUB_PUB_KEYS: 'remuslazar'
      WWW_PORT: 8080
      DB_HOST: db-test
      COMPOSER_INSTALL_PARAMS: '--dev --prefer-dist'
      SETUP_BEHAT: 'true'
      FLOW_CONTEXT: 'Development/Behat'
      SITE_PACKAGE: 'CRON.DavShop'
      SITE_INIT_SCRIPT: 'init.sh'
      ADMIN_PASSWORD: 'password'
    working_dir: /data/www/Packages/Sites/CRON.DavShop/Tests/Behavior
    command: "sudo -u www-data /data/www/bin/behat --ansi"

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
  elasticsearch:
    build: ./docker/elasticsearch
    ports:
      - 9200:9200

volumes:
  data:

networks:
  default:
```

To run the full behat suite in a "unattended" mode:

```bash
docker-compose -f docker-compose.behat-runner.yml up --abort-on-container-exit
```

This will run the suite and exit afterwards.
