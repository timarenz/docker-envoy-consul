#!/bin/bash

docker push "${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${ENVOY_VERSION}_${CONSUL_VERSION}"

if (${LATEST}); then 
  docker push "${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:latest"
fi