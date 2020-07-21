FROM gradle:6.5.1-jdk8 AS build

COPY --chown=gradle:gradle . /home/gradle/src

WORKDIR /home/gradle/src

RUN gradle build --no-daemon 

FROM openjdk:11.0.7

COPY --from=containers.instana.io/instana/release/aws/fargate/jvm:latest /instana /instana
ENV JAVA_TOOL_OPTIONS="-javaagent:/instana/instana-fargate-collector.jar"

COPY --from=build /home/gradle/src/build/libs/spring-music-1.0.jar app.jar

ENTRYPOINT ["java", "-jar", "/app.jar"]