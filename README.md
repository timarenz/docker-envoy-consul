# docker-envoy-consul

[![Build Status](https://travis-ci.org/timarenz/docker-envoy-consul.svg?branch=master)](https://travis-ci.org/timarenz/docker-envoy-consul)

This repo is used to build all [supported combinations](https://www.consul.io/docs/connect/proxies/envoy.html) of Envoy and Consul into a single Docker image for testing.

All Docker images can be found at: <https://hub.docker.com/r/timarenz/envoy-consul>

If a version is missing please feel free to open a pull request with the update matrix build in the `.travis.yml`.
Make sure to change the `LATEST` variable if there is a newer version.
