setup:
	@docker build . -t internxt-webdav --progress=plain

up: WEBDAV_PORT = 80
up:
	@docker run --rm --name internxt-webdav \
        --cap-add NET_ADMIN \
        -v /sys/fs/cgroup/internxt-webdav:/sys/fs/cgroup:rw \
        --env-file .env \
        -p 127.0.0.1:$(WEBDAV_PORT):80 \
        internxt-webdav

down:
	-@docker stop internxt-webdav

shell:
	@docker exec -it internxt-webdav /bin/sh
