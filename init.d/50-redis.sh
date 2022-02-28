#!/bin/sh

chown -R redis:redis /var/lib/redis

chown root:redis /var/lib/redis
chmod 0750 /var/lib/redis

find /var/lib/redis -type f -print0 | xargs -0 --no-run-if-empty chmod 0640

