#!/bin/sh

if ! redis-cli INCR testcounter | grep -E "^1$"; then
	echo "CHECK FAILED (redis): No response to INCR"
	false
fi

