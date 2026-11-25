# Stage 1: build the jar
FROM maven:3.9-eclipse-temurin-17 AS build
ARG SERVICE
WORKDIR /src
COPY . .
RUN mvn -B -pl ${SERVICE} -am clean package -DskipTests -Djib.skip=true

# Stage 2: small runtime image
FROM eclipse-temurin:17-jre
ARG SERVICE
WORKDIR /app
COPY --from=build /src/${SERVICE}/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
