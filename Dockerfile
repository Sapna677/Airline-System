# Stage 1: Build/Compile Java classes
FROM eclipse-temurin:17-jdk AS builder
WORKDIR /app
COPY src/main/java/mypack /app/src/mypack
COPY src/main/webapp/WEB-INF/lib /app/lib
RUN mkdir -p /app/classes
# Compile Java files using the libraries in WEB-INF/lib as classpath
RUN javac -d /app/classes -cp "/app/lib/*" /app/src/mypack/*.java

# Stage 2: Create Tomcat container
FROM tomcat:10.1-jdk17
WORKDIR /usr/local/tomcat

# Remove default ROOT application to make it load faster
RUN rm -rf webapps/ROOT

# Copy webapp directories (JSPs, CSS, JS, images, WEB-INF)
COPY src/main/webapp /usr/local/tomcat/webapps/ROOT

# Copy compiled classes to WEB-INF/classes
COPY --from=builder /app/classes /usr/local/tomcat/webapps/ROOT/WEB-INF/classes

EXPOSE 8080
CMD ["catalina.sh", "run"]
