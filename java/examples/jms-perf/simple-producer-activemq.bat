@echo off

set ACTIVEMQ_DIR=C:/apps/activemq-5.4.0

java -classpath ^
target/jms-perf-1.0.jar;^
%ACTIVEMQ_DIR%/activemq-all-5.4.0.jar;^
%M2_REPO%/javax/jms/jms/1.1/jms-1.1.jar;^
%M2_REPO%/log4j/log4j/1.2.16/log4j-1.2.16.jar;^
%M2_REPO%/org/slf4j/slf4j-api/1.6.1/slf4j-api-1.6.1.jar;^
%M2_REPO%/org/slf4j/slf4j-log4j12/1.6.1/slf4j-log4j12-1.6.1.jar;^
    org.archfirst.jmsproducer.SimpleProducer config/jndi-activemq.properties config/simple-client-activemq.properties