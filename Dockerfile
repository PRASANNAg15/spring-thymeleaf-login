# ---------- BUILD STAGE ----------
FROM amazoncorretto:25-alpine3.22-jdk AS builder

WORKDIR /build

# Copy pom.xml first (enables Docker layer caching)
COPY pom.xml .

# Copy Maven wrapper files if present
COPY mvnw .
COPY .mvn .mvn

# Download dependencies (cached if pom.xml unchanged)
RUN ./mvnw -B dependency:go-offline

# Copy the full project
COPY src src

# Build the JAR
RUN ./mvnw -B clean package -DskipTests


# ---------- RUNTIME STAGE ----------
FROM amazoncorretto:25-alpine3.22-jdk

WORKDIR /app

# Copy only the final JAR from build stage
COPY --from=builder /build/target/spring-thymeleaf-login-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]
