FROM maven:3.6.1-jdk-11-slim as maven
WORKDIR /bayou
COPY pom.xml pom.xml
COPY src src
RUN mvn compile assembly:single -q

FROM openjdk:11.0.3-jre-slim
WORKDIR /bayou
COPY --from=maven /bayou/target/bayou_TFB-0.1-jar-with-dependencies.jar app.jar
CMD ["java", "-jar", "app.jar"]
