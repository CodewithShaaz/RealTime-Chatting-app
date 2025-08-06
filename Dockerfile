# ===== STAGE 1: Build the application =====
FROM eclipse-temurin:17-jdk as builder

# Set working directory
WORKDIR /app

# Copy Maven wrapper files and pom.xml
COPY mvnw mvnw.cmd pom.xml ./
COPY .mvn .mvn

# Copy all source code
COPY src src

# Run Maven build (skip tests for faster build)
RUN ./mvnw package -DskipTests

# ===== STAGE 2: Run the application =====
FROM eclipse-temurin:17-jdk

# Set working directory
WORKDIR /app

# Copy built JAR from the builder stage
COPY --from=builder /app/target/app-0.0.1-SNAPSHOT.jar app.jar

# Expose port (default Spring Boot port)
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
