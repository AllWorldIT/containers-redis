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


FROM registry.conarx.tech/containers/alpine/3.17


ARG VERSION_INFO=
LABEL org.opencontainers.image.authors   = "Nigel Kukard <nkukard@conarx.tech>"
LABEL org.opencontainers.image.version   = "3.17"
LABEL org.opencontainers.image.base.name = "registry.conarx.tech/containers/alpine/3.17"


RUN set -ex; \
	true "Redis"; \
	apk add --no-cache redis; \
	true "Cleanup"; \
	rm -f /var/cache/apk/*

# Disable listening on only localhost
RUN set -ex; \
	sed -ire 's,^bind\(.*\),#bind\1,' /etc/redis.conf; \
	grep -E '^#bind' /etc/redis.conf

# Redis
COPY etc/supervisor/conf.d/redis.conf /etc/supervisor/conf.d/redis.conf
COPY usr/local/share/flexible-docker-containers/init.d/42-redis.sh /usr/local/share/flexible-docker-containers/init.d
COPY usr/local/share/flexible-docker-containers/tests.d/42-redis.sh /usr/local/share/flexible-docker-containers/tests.d
COPY usr/local/share/flexible-docker-containers/healthcheck.d/42-redis.sh /usr/local/share/flexible-docker-containers/healthcheck.d
RUN set -ex; \
	true "Flexible Docker Containers"; \
	if [ -n "$VERSION_INFO" ]; then echo "$VERSION_INFO" >> /.VERSION_INFO; fi; \
	true "Permissions"; \
	mkdir /etc/redis; \
	chown root:root \
		/etc/supervisor/conf.d/redis.conf; \
	chmod 0644 \
		/etc/supervisor/conf.d/redis.conf; \
	chown root:redis \
		/etc/redis.conf \
		/etc/redis; \
	chmod 0640 \
		/etc/redis.conf; \
	chmod 0750 \
		/etc/redis; \
	fdc set-perms

VOLUME ["/var/lib/redis"]

EXPOSE 6379
