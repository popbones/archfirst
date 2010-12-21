This sample shows the use of JPA and JAXB together. We use the real schema
from Bullsfirst. Data is read from the bfoms_javaee database and written out
as XML. For this sample to work correctly, make sure that the bfoms_javaee
database is set up with correct schema and loaded with User related data.

Output is shown below:

<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<User>
    <Id>1</Id>
    <Username>jhorner</Username>
    <PasswordHash>bDUBbzggM5St3G4xCJBX3w==</PasswordHash>
    <Enabled>true</Enabled>
    <Person>
        <Id>1</Id>
        <FirstName>John</FirstName>
        <LastName>Horner</LastName>
    </Person>
    <Role>
        <Id>2</Id>
        <Name>customer</Name>
    </Role>
</User>