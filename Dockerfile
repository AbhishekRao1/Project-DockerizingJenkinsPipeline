FROM maven:3-alpine

COPY pom.xml pipeline/

COPY jenkins/scripts/deliver.sh pipeline/

COPY src/ pipeline/src/

WORKDIR pipeline/

RUN mvn clean install

ENTRYPOINT ["/pipeline/deliver.sh"]
