FROM maven:3.9-eclipse-temurin-21 AS build
ARG DRIVER_VERSION=1.1.3.RELEASE
WORKDIR /repro
COPY pom.xml .
COPY src ./src
RUN mvn -B -Ddriver.version=${DRIVER_VERSION} package dependency:copy-dependencies
RUN mvn -B -Ddriver.version=${DRIVER_VERSION} dependency:tree > dependencies.txt

FROM eclipse-temurin:21-jdk
WORKDIR /repro
COPY --from=build /repro/target/classes ./classes
COPY --from=build /repro/target/dependency ./lib
COPY --from=build /repro/dependencies.txt ./dependencies.txt
ENTRYPOINT ["java", "-Xmx128m", "-Dreactor.netty.ioWorkerCount=2", "-cp", "/repro/classes:/repro/lib/*", "DnsLeakRepro"]
