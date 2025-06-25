# ---------- Stage 1: Build WAR using Maven ----------
    FROM maven:3.8.5-eclipse-temurin-8 AS builder

    WORKDIR /app
    
    # Copy Maven project files
    COPY pom.xml .
    COPY src ./src
    
    # Build the WAR file
    RUN mvn clean package -DskipTests
    
    
    # ---------- Stage 2: Lightweight Tomcat Runtime ----------
    FROM tomcat:9.0.53-jdk8-openjdk-slim
    
    WORKDIR /usr/local/tomcat
    
    # Install curl
    RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
    
    # Use CATALINA_OPTS to force shutdown of Guava Finalizer thread
    ENV CATALINA_OPTS="-Dcom.google.common.util.concurrent.ForceFinalizerThreadShutdown=true"
    
    # Clean up default apps to reduce image size
    RUN rm -rf webapps/*
    
    # Change default Tomcat port from 8080 to 8443 in server.xml
    RUN sed -i 's/port="8080"/port="8443"/' conf/server.xml
    
    # Copy WAR file from builder and keep it as cvist.war
    COPY --from=builder /app/target/*.war webapps/cvist.war
    
    # Copy config files
    COPY ConfigDefault.xml bin/ConfigDefault.xml
    COPY Config.xml bin/Config.xml
    COPY ConfigDefault.xml ConfigDefault.xml
    COPY Config.xml Config.xml
    
    # Expose updated port
    EXPOSE 8443
    
    # Start Tomcat
    CMD ["catalina.sh", "run"]
    