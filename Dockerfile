FROM registry.gitlab.iitsp.com/allworldit/docker/alpine:latest

ARG VERSION_INFO=
LABEL maintainer="Nigel Kukard <nkukard@lbsd.net>"

RUN set -ex; \
	true "Redis"; \
	apk add --no-cache redis; \
	true "Versioning"; \
	if [ -n "$VERSION_INFO" ]; then echo "$VERSION_INFO" >> /.VERSION_INFO; fi; \
	true "Cleanup"; \
	rm -f /var/cache/apk/*

# Disable listening on only localhost
RUN set -ex; \
	sed -ire 's,^bind\(.*\),#bind\1,' /etc/redis.conf; \
	cat /etc/redis.conf; \
	grep -E '^#bind' /etc/redis.conf

# Redis
COPY etc/supervisor/conf.d/redis.conf /etc/supervisor/conf.d/redis.conf
COPY init.d/50-redis.sh /docker-entrypoint-init.d/50-redis.sh
COPY tests.d/50-redis.sh /docker-entrypoint-tests.d/50-redis.sh
RUN set -ex; \
	chown root:root \
		/etc/supervisor/conf.d/redis.conf \
		/docker-entrypoint-init.d/50-redis.sh \
		/docker-entrypoint-tests.d/50-redis.sh; \
	chmod 0644 \
		/etc/supervisor/conf.d/redis.conf; \
	chmod 0755 \
		/docker-entrypoint-init.d/50-redis.sh \
		/docker-entrypoint-tests.d/50-redis.sh

VOLUME ["/var/lib/redis"]

EXPOSE 6379

