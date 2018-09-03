Docker Neos Testing
===================

Abstract
--------

This is basically an add-on to the [Docker Neos Alpine](https://hub.docker.com/r/remuslazar/docker-neos-alpine/) image adding support
for Behat Tests.

Important Note
--------------

** Currently this project is in a WIP state, not fully functional or useful. **

Usage
-----

Make sure to install dev packages and executed `behat:setup`:

As user www-data:

```bash
composer install --dev
./flow behat:setup
```

WIP..
