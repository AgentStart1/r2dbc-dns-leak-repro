# PostgreSQL R2DBC DNS socket retention reproduction

Compare `r2dbc-postgresql` 1.1.2.RELEASE and 1.1.3.RELEASE with the other dependencies held constant. The program opens and closes 30 driver network clients by DNS hostname and counts UDP sockets in its own Linux network namespace.

This uses `ReactorNettyClient`, an internal driver API, to isolate connection/DNS behavior. A tiny TCP endpoint replaces PostgreSQL. No database, credentials, authentication or SQL are needed. It is not an end-to-end database test.

## Run

Requires Docker Engine with Linux containers and Docker Compose v2. Internet access is needed for the official container images and Maven Central dependencies.

```sh
docker compose build
docker compose up -d --wait endpoint
docker compose run --rm driver112
docker compose run --rm driver113
docker compose down
```

The driver JAR location is printed to verify the selected version. UDP4 and UDP6 counts are printed before the loop, every five closed connections, and after a request for garbage collection. DNS lookup requires the hostname `endpoint`; replacing it with an IP changes the tested path.

Both runs pin Reactor Netty 1.1.22, Reactor Core 3.7.12 and Netty 4.1.112.Final. This compares only the driver version, not each release's default transitive dependency set. A fresh container isolates socket counts from unrelated applications; compare growth from baseline rather than requiring an absolute baseline of zero.

Expected reproduction: 1.1.2 remains at its baseline, while 1.1.3 retains approximately one additional UDP socket per closed connection. Socket address family depends on the environment. See [results](results/) for captured output and [DEVELOPMENT.md](DEVELOPMENT.md) for dependency inspection.

Related upstream discussions: [R2DBC #724](https://github.com/pgjdbc/r2dbc-postgresql/pull/724), [R2DBC #412](https://github.com/pgjdbc/r2dbc-postgresql/issues/412), and [Reactor Netty #2878](https://github.com/reactor/reactor-netty/issues/2878).
