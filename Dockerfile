FROM maven:3.8.4-openjdk-17-slim AS build
WORKDIR /app

# Copy pom.xml and download project dependencies
COPY pom.xml .
COPY src ./src
RUN mvn dependency:go-offline -B

# Copy the source code and build the application
COPY . .
RUN mvn clean package -DskipTests

# Use an official OpenJDK runtime image to run the Spring Boot app
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copy the jar file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the application port
EXPOSE 8080

# Run the Spring Boot app
ENTRYPOINT ["java", "-jar", "app.jar"]


