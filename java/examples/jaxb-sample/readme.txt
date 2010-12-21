This sample shows the use of JAXB to marshall and unmarshall an object graph
rooted at BrokerageAccount. BrokerageAccount contains a set of Orders and every
Order contains a referece back to its BrokerageAccount. Note that JAXB cannot
serialize cycles in object graphs. So the cycle must be broken by the use
of the @XmlTransient annotation. As you can see from the output below, the
read order looses the reference back to the account.

Original Account
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<BrokerageAccount>
    <Id>1000</Id>
    <Name>John's Brokerage Account</Name>
    <CashPosition>1000.0</CashPosition>
    <Order>
        <Id>101</Id>
        <Side>Buy</Side>
        <Symbol>GOOG</Symbol>
        <Quantity>1000</Quantity>
    </Order>
</BrokerageAccount>


Original Order:
101: Buy GOOG, quantity=1000, account=1000

Read Account
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<BrokerageAccount>
    <Id>1000</Id>
    <Name>John's Brokerage Account</Name>
    <CashPosition>1000.0</CashPosition>
    <Order>
        <Id>101</Id>
        <Side>Buy</Side>
        <Symbol>GOOG</Symbol>
        <Quantity>1000</Quantity>
    </Order>
</BrokerageAccount>


Read Order:
101: Buy GOOG, quantity=1000, account=null