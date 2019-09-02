ARG CONSUL_IMAGE
ARG ENVOY_IMAGE

FROM ${CONSUL_IMAGE} as consul

FROM ${ENVOY_IMAGE}
COPY --from=consul /bin/consul /bin/consul
ENTRYPOINT ["/docker-entrypoint.sh", "consul", "connect", "envoy"]