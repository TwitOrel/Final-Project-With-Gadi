FROM openjdk:11-jdk

RUN apt-get update && apt-get install -y imagemagick

WORKDIR /app

COPY Watermark.java .

RUN javac Watermark.java

ENTRYPOINT ["java", "-cp", "/app", "Watermark"]
