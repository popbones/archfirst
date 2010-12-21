Execute the following command to run the test with Glassfish 3.1 embedded container:

    > mvn test -Pglassfish-embedded-3

Execute the following command to run the test with JBoss 6.0 remote container:

    > mvn test -Pjbossas-remote-6

P.S. The JBoss test currently fails because it cannot find
javax.activation:activation:jar:1.0.2 in any Maven repository