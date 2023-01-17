[![pipeline status](https://gitlab.conarx.tech/containers/redis/badges/main/pipeline.svg)](https://gitlab.conarx.tech/containers/redis/-/commits/main)

# Container Information

[Container Source](https://gitlab.conarx.tech/containers/redis) - [GitHub Mirror](https://github.com/AllWorldIT/containers-redis)

This is the Conarx Containers Redis image, it provides the Redis server.



# Mirrors

|  Provider  |  Repository                            |
|------------|----------------------------------------|
| DockerHub  | allworldit/redis                      |
| Conarx     | registry.conarx.tech/containers/redis |



# Commercial Support

Commercial support is available from [Conarx](https://conarx.tech).



# Environment Variables

Additional environment variables are available from...
* [Conarx Containers Alpine image](https://gitlab.conarx.tech/containers/alpine).


## REDIS_PASSWORD

Set a password for Redis. By default there is no password.



# Volumes


## /var/lib/redis

Redis data directory.



# Exposed Ports

Redis port 6379 is exposed.



# Configuration

Configuration files of note can be found below...

| Path                 | Description             |
|----------------------|-------------------------|
| /etc/redis/users.acl | Redis ACL configuration |
