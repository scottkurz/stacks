# Step 1: Build the user's application
FROM adoptopenjdk/openjdk8-openj9

RUN apt-get update && \
    apt-get install -y maven unzip wget xmlstarlet

# Copy and build the dev.appsody:java-openliberty parent pom
COPY ./pom.xml /project/pom.xml
RUN cd /project && mvn -B install dependency:go-offline -DskipTests

# Copy and run a simple version check
COPY ./util /project/util
RUN  /project/util/check_version build

# Copy the user's application pom and resolve all dependencies, also trigger Open Liberty install
COPY ./validate.sh /project/user-app/validate.sh
COPY ./user-app/pom.xml 
RUN cd /project/user-app && ./validate.sh

# Copy and build the application source, and run unit tests
COPY ./user-app /project/user-app
RUN cd /project/user-app && mvn liberty:create package

RUN cd /project/user-app/target/liberty/wlp/usr/servers && \
    mkdir /config && \
    mv defaultServer/* /config/ && \
    mkdir /shared && \
    mv ../shared/* /shared/

# Step 2: Package Open Liberty image
FROM open-liberty:kernel-java8-openj9

# 2a) shared resources change the least-frequently
COPY --chown=1001:0 --from=0 /shared/resources /opt/ol/wlp/usr/shared/

# 2b) next copy shared library
COPY --chown=1001:0 --from=0 /config/libs/ /config/

# 2c) Server config, bootstrap.properties, and everything else
COPY --chown=1001:0 --from=0 /config/ /config/

# 2d) Changes to the application binary
COPY --chown=1001:0 --from=0 /project/user-app/target/*.war /config/apps


EXPOSE 9080
EXPOSE 9443
