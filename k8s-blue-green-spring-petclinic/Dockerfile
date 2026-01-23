FROM  eclipse-temurin:21-jre

WORKDIR /app

COPY target/* /app/

EXPOSE 8080

ENTRYPOINT [ "java","-jar","app.jar" ]