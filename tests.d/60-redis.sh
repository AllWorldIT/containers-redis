#!/bin/sh

# Check if our healthcheck works
/usr/bin/healthcheck

if [ -n "$REDIS_PASSWORD" ]; then
	echo "CHECK INFO (redis): Testing with password"
	export REDISCLI_AUTH=$REDIS_PASSWORD
fi

if ! redis-cli INCR testcounter | grep -E "^1$"; then
	echo "CHECK FAILED (redis): No response to INCR"
	false
fi

unset REDISCLI_AUTH
