FROM docker.artifactory.weedon.org.au/redwyvern/java-devenv-base
MAINTAINER Nick Weedon <nick@weedon.org.au>

ARG APP_GROUP_ID
ARG APP_ARTIFACT_ID
ARG APP_VERSION
ARG ARTIFACTORY_URL


# Create new user so that we are not running the server as root
RUN useradd -m -d /home/jservice -s /bin/bash jservice

RUN 	mkdir /home/jservice/.m2 && cp /root/.m2/settings.xml /home/jservice/.m2 && \
        chown -R jservice.jservice /home/jservice

USER jservice

ENV SERVICE_JAR_FILE ${APP_ARTIFACT_ID}-${APP_VERSION}.jar

# Download and copy the JAR and then remove dependencies of the plugin we used
RUN     mkdir ~/service && cd ~/service && \
        mvn -B -U org.apache.maven.plugins:maven-dependency-plugin:2.8:get -DgroupId=${APP_GROUP_ID} -DartifactId=${APP_ARTIFACT_ID} -Dversion=${APP_VERSION} -Dtype=jar -Dtransitive=false && \
        bash -c 'cp ~/.m2/repository/$(tr "." "/" <<<${APP_GROUP_ID})/${APP_ARTIFACT_ID}/${APP_VERSION}/${SERVICE_JAR_FILE} $HOME/service' && \
        rm -r ~/.m2/repository/*

# Standard SSH port
EXPOSE 22

# Default command
CMD /usr/bin/java -jar ${HOME}/service/${SERVICE_JAR_FILE}

