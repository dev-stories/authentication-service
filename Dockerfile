FROM maven:3.8.6-openjdk-18 AS build
RUN mkdir -p /workspace
WORKDIR /workspace
COPY pom.xml /workspace
COPY src /workspace/src
RUN mvn -f pom.xml clean install
FROM openjdk:18
COPY --from=build /workspace/target/*.jar app.jar
COPY scripts/wait-db.sh /wait-db.sh
RUN chmod +x /wait-db.sh
EXPOSE 8081
ENTRYPOINT ["sh", "/wait-db.sh", "java","-jar","app.jar","--env-file=./.env"]