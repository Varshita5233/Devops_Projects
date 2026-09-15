# ---------- Stage 1: Build ----------
FROM maven:3.9.9-eclipse-temurin-21 AS builder

WORKDIR /build

# Copy pom.xml first (better caching)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build the jar
RUN mvn clean package -DskipTests


# ---------- Stage 2: Runtime ----------

# 1) Use lightweight Java runtime
FROM eclipse-temurin:21-jre

# 2) Set work directory inside container
WORKDIR /app

# 3) Copy your built jar into the container
COPY --from=builder /build/target/*.jar app.jar

# 4) Expose port (for documentation + mapping)
EXPOSE 8080

# 5) Start the jar
ENTRYPOINT ["java","-jar","/app/app.jar"]

