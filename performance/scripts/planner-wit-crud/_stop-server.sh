#!/bin/bash

docker info > /dev/null
DOCKER_STATUS=$?
if [ $DOCKER_STATUS -gt 0 ]; then
	exit 1;
fi

#curl -L --silent https://raw.githubusercontent.com/fabric8-services/fabric8-wit/master/docker-compose.yml > docker-compose.yml
docker-compose down
docker-compose rm -f
