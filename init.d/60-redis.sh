#!/bin/sh

chown -R redis:redis /var/lib/redis

chown root:redis /var/lib/redis
chmod 0770 /var/lib/redis

echo "NOTICE: Initializing settings"

# Setup the password
if [ -n "$REDIS_PASSWORD" ]; then
	# Enable ACL file
	sed -ri "s!^#?\s*(aclfile)\s+\S+.*!\1 /etc/redis/users.acl!" /etc/redis.conf
	grep -q -E "^aclfile /etc/redis/users.acl" /etc/redis.conf
	# Setup default user
	if [ ! -s /etc/redis/users.acl ]; then
		echo "user default on +@all ~* &* >$REDIS_PASSWORD" > /etc/redis/users.acl
	fi
	# Fixup perms
	chmod 0640 /etc/redis/users.acl
	chown root:redis /etc/redis/users.acl
fi

# Fix main config perms
chmod 0640 /etc/redis.conf
chown root:redis /etc/redis.conf

