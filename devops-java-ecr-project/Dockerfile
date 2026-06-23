FROM maven:3.8.4-openjdk-11-slim AS BUILD
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests 

FROM eclipse-temurin:11-jre-alpine
WORKDIR /app
COPY --from=BUILD /app/target/devops-sprint-1.0.0.jar app.jar
EXPOSE 8080
ENTRYPOINT [ "java","-jar","app.jar" ]