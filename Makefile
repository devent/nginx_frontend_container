VERSION := 1.11
NAME := nginx-frontend
CONF := nginx.conf
SITES := sites
DNS_SERVER  := 172.17.0.3

define DOCKER_CMD :=
docker run \
--name $(NAME) \
--dns=$(DNS_SERVER) \
-v "`realpath $(CONF)`:/etc/nginx/nginx.conf:ro" \
-v "`realpath $(SITES)`:/etc/nginx/sites-enabled:ro" \
-p 80:80 \
-d \
nginx:$(VERSION)
endef

include ../make_utils/Makefile.help
include ../make_utils/Makefile.functions
include ../make_utils/Makefile.container

.PHONY +: run rerun rm clean test restart bash

run: _run ##@default Starts the container.

rerun: _rerun ##@targets Stops and starts the container.

rm: _rm ##@targets Stops and removes the container.

clean: _clean ##@targets Stops and removes the container and removes all created files.

test: _test ##@targets Tests if the container is running.

restart: ##@targets Restarts the container.
	if $(container_run); then \
	docker exec $(NAME) nginx -s reload; \
	else \
	$(MAKE) rerun; \
	fi

bash: test _bash ##@targets Executes the bash inside the running container.
