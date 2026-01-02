# ---------- BUILD STAGE ----------
FROM maven:3.9.9-eclipse-temurin-21-alpine AS builder

WORKDIR /build

# Copy pom.xml first (better caching)
COPY pom.xml .

# Download dependencies
RUN mvn -B dependency:go-offline

# Copy source code
COPY src src

# Build jar
RUN mvn -B clean package -DskipTests


# ---------- RUNTIME STAGE ----------
FROM amazoncorretto:25-alpine3.22-jdk

WORKDIR /app

COPY --from=builder /build/target/spring-thymeleaf-login-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]
