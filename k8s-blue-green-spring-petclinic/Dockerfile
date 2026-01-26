FROM  maven:3.9.6-eclipse-temurin-21 AS BUILDER

WORKDIR /build

COPY pom.xml .

COPY src ./src

RUN mvn clean package -DskipTests

FROM eclipse-temurin:21-jdk-alpine

WORKDIR /app

RUN apk add --no-cache netcat-openbsd

COPY --from=BUILDER /build/target/*.jar app.jar

EXPOSE 8080

CMD sh -c 'echo "Waiting for MySQL..."; \
           until nc -z mysql 3306; do sleep 2; done; \
           echo "MySQL is UP — starting app"; \
           java -jar app.jar'