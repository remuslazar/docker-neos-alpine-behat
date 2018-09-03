#!/bin/bash

set -e
set -u

# We have TTY, so probably an interactive container...
if test -t 0; then
  # Run init in background
  /init &
  echo "$(getent hosts  web | awk '{print$1}') behat.dev.local" >> /etc/hosts
  export FLOW_CONTEXT=Testing/Behat
  # Some command(s) has been passed to container? Execute them and exit.
  # No commands provided? Run bash.
  if [[ $@ ]]; then
    su www-data -c $@
  else
    export PS1='[\u@\h : \w]\$ '
    su www-data
  fi

# Detached mode? Run init, which will stay until container is stopped.
else
  if [[ $@ ]]; then
    eval $@
  fi
  /init
fi
