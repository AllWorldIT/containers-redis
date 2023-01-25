#!/bin/bash
# Copyright (c) 2022-2023, AllWorldIT.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.


fdc_notice "Setting up Redis permissions"
chown root:redis /var/lib/redis
chmod 0770 /var/lib/redis
# Fix main config perms
chmod 0640 /etc/redis.conf
chown root:redis /etc/redis.conf

fdc_notice "Initializing Redis settings"

# Setup the password
if [ -n "$REDIS_PASSWORD" ] || [ -e /etc/redis/users.acl ]; then
	fdc_info "Enabling Redis user ACL"
	# Enable ACL file
	sed -ri "s!^#?\s*(aclfile)\s+\S+.*!\1 /etc/redis/users.acl!" /etc/redis.conf
	grep -q -E "^aclfile /etc/redis/users.acl" /etc/redis.conf
	# Setup default user
	if [ -n "$REDIS_PASSWORD" ] && [ ! -s /etc/redis/users.acl ]; then
		fdc_info "Setting Redis password"
		echo "user default on +@all ~* &* >$REDIS_PASSWORD" > /etc/redis/users.acl
	fi
fi
# Fixup perms on users.acl if it exists
if [ -e /etc/redis/users.acl ]; then
	chmod 0640 /etc/redis/users.acl
	chown root:redis /etc/redis/users.acl
fi
