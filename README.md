# docker-envoy-consul

[![Build Status](https://travis-ci.org/timarenz/docker-envoy-consul.svg?branch=master)](https://travis-ci.org/timarenz/docker-envoy-consul)

This repo is used to build all [supported combinations](https://www.consul.io/docs/connect/proxies/envoy.html) of Envoy and Consul into a single Docker image for testing.

All Docker images can be found at: <https://hub.docker.com/r/timarenz/envoy-consul>

## Usage

This Docker images including both Consul and Envoy and is a good way to run Envoy proxies on bare-metal, VMs or system where the sidecar proxies are not or can not be injected automatically.
Also, as per [Consul version 1.8](https://www.hashicorp.com/blog/announcing-hashicorp-consul-1-8/), they can be used to run Ingress and Terminating Gateways.

More information about the general usage can be found in the Consul Connect Envoy documentation: <https://www.consul.io/docs/commands/connect/envoy>
However, for a quick start you will find a couple of examples below.

### Run a basic sidecar proxy

The sidecar Envoy process can be started with.

```bash
docker run -d --network host --name db-sidecar-proxy timarenz/envoy-consul:v1.14.1_1.8.0-beta1 \
  -sidecar-for db
```

### Additional Envoy Arguments

To pass additional arguments directly to Envoy, for example output logging level, you can use:

```bash
docker run -d --network host --name db-sidecar-proxy timarenz/envoy-consul:v1.14.1_1.8.0-beta1 \
  -sidecar-for db \
  -- -l debug
```

### Multiple Proxy Instances

To run multiple different proxy instances on the same host, you will need to use `-admin-bind` (<https://www.consul.io/docs/commands/connect/envoy#admin-bind>) on all but one to ensure they don't attempt to bind to the same port as in the following example.

```bash
docker run -d --network host --name db-sidecar-proxy timarenz/envoy-consul:v1.14.1_1.8.0-beta1 \
  -sidecar-for db \
  -admin-bind localhost:19001
```

### Mesh Gateways

```bash
docker run -d --network host --name mesh-gateway timarenz/envoy-consul:v1.14.1_1.8.0-beta1 \
  -gateway=mesh -register \
  -address '{{ GetInterfaceIP "eth0" }}:8443' \
  -wan-address '{{ GetInterfaceIP "eth1" }}:8443'
```

### Mesh Gateways with support for WAN Federation

There needs to be at least one mesh gateway configured to opt-in to exposing the servers in its configuration. When using the consul connect envoy CLI this is done by using the flag `-expose-servers`.

```bash
docker run -d --network host --name server-mesh-gateway timarenz/envoy-consul:v1.14.1_1.8.0-beta1 \
  -gateway=mesh -register \
  -address '{{ GetInterfaceIP "eth0" }}:8443' \
  -wan-address '{{ GetInterfaceIP "eth1" }}:8443' \
  -expose-servers
```

### Terminating Gateways

The terminating gateway Envoy process can be auto-registered and started with the following command.

```bash
docker run -d --network host --name terminating-gateway timarenz/envoy-consul:v1.14.1_1.8.0-beta1 \
  -gateway=terminating -register \
  -service my-gateway \
  -address '{{ GetInterfaceIP "eth0" }}:8443'
```

### Ingress Gateways

The ingress gateway Envoy process can be auto-registered and started with the following command.

```bash
docker run -d --network host --name ingress-gateway timarenz/envoy-consul:v1.14.1_1.8.0-beta1 \
  -gateway=ingress -register \
  -service ingress-service \
  -address '{{ GetInterfaceIP "eth0" }}:8888'
```

### Remarks

As you see the Docker images are run with the `--network host`) option. This is required for as the Consul binary and Envoy proxy needs to talk to the Consul API and GRPC endpoint.
It is a best practices to always talk to a local Consul agent, however you could address a different API endpoint using the `-http-addr=<addr>` (<https://www.consul.io/docs/commands/connect/envoy#http-addr>) parameter and the `-grpc-addr=<addr>` (<https://www.consul.io/docs/commands/connect/envoy#grpc-addr>) parameter to use a different GRPC endpoint.

## Contribute

If a version is missing please feel free to open a pull request with the update matrix build in the `.travis.yml`.
Make sure to change the `LATEST` variable if there is a newer version.
