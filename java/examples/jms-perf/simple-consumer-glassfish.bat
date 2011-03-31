@echo off
java -classpath ^
target/jms-perf-1.0.jar;^
%GLASSFISH_HOME%/modules/gf-client-module.jar;^
glassfish-jms-libs/imqjmsra.jar;^
glassfish-jms-libs/imqbroker.jar;^
%M2_REPO%/log4j/log4j/1.2.16/log4j-1.2.16.jar;^
%M2_REPO%/org/slf4j/slf4j-api/1.6.1/slf4j-api-1.6.1.jar;^
%M2_REPO%/org/slf4j/slf4j-log4j12/1.6.1/slf4j-log4j12-1.6.1.jar;^
    org.archfirst.jmsconsumer.SimpleConsumer config/jndi-glassfish.properties config/app-glassfish.properties