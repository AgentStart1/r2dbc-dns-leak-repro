FROM eclipse-temurin:21-jdk AS build
RUN mkdir -p /opt/maven && curl -fLsS --retry 3 https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.9.9/apache-maven-3.9.9-bin.tar.gz | tar -xz --strip-components=1 -C /opt/maven
ENV PATH=/opt/maven/bin:$PATH
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
