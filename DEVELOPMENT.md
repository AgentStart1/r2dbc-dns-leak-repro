# Development

The Java 21 program deliberately calls the internal driver network API. The TCP endpoint consumes bytes until EOF without implementing PostgreSQL. Separate Compose run containers provide separate network namespaces for the two versions.

To inspect the effective dependency tree:

```sh
docker compose run --rm --entrypoint cat driver112 /repro/dependencies.txt
docker compose run --rm --entrypoint cat driver113 /repro/dependencies.txt
```

The Maven build compiles the reproduction. Verification consists of running both versions and comparing UDP growth after each connection is closed. `System.gc()` is only a GC request; socket retention throughout the loop is the primary measurement.

The reproduction does not attribute a particular retained heap size to DNS resources and does not test SQL, authentication, TLS, cancellation or reconnection compatibility.
