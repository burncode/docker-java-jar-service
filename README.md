Docker Java Jar Service
=======================

This is a general purpose Java container that runs standalone JAR files.

Example
-------

```
docker build . --build-arg APP_GROUP_ID=com.redwyvern --build-arg APP_ARTIFACT_ID=strength-tailor-server --build-arg APP_VERSION=1.0.0-SNAPSHOT --build-arg ARTIFACTORY_URL=http://artifactory.weedon.org.au -t testbuild
```

