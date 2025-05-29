# Build Stage
FROM gradle:8.14-jdk17 AS builder
WORKDIR /app
COPY --chown=gradle:gradle . .
RUN gradle build -x test

# Execute Stage
FROM openjdk:17-jdk-slim
ENV HOME_DIR=/apps/lib/
WORKDIR $HOME_DIR
COPY --from=builder /app/build/libs/*.jar search-jenkins-pipeline.jar
EXPOSE 8080
ENTRYPOINT ["java", "-Dspring.profiles.active=local", "-jar", "search-jenkins-pipeline.jar"]