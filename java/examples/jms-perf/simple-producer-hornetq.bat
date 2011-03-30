@echo off
java -classpath ^
target/jms-perf-1.0.jar;^
%M2_REPO%/javax/jms/jms/1.1/jms-1.1.jar;^
%M2_REPO%/jboss/jbossall-client/3.2.3/jbossall-client-3.2.3.jar;^
%M2_REPO%/log4j/log4j/1.2.16/log4j-1.2.16.jar;^
%M2_REPO%/org/hornetq/hornetq-core/2.1.2.Final/hornetq-core-2.1.2.Final.jar;^
%M2_REPO%/org/hornetq/hornetq-jms/2.1.2.Final/hornetq-jms-2.1.2.Final.jar;^
%M2_REPO%/org/jboss/netty/netty/3.2.4.Final/netty-3.2.4.Final.jar;^
%M2_REPO%/org/slf4j/slf4j-api/1.6.1/slf4j-api-1.6.1.jar;^
%M2_REPO%/org/slf4j/slf4j-log4j12/1.6.1/slf4j-log4j12-1.6.1.jar;^
    org.archfirst.jmsproducer.SimpleProducer config/jndi-hornetq.properties config/app-hornetq.properties