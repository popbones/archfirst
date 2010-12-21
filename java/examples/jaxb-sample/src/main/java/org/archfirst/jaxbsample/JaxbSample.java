/**
 * Copyright 2010 Archfirst
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.archfirst.jaxbsample;

import java.io.StringReader;
import java.io.StringWriter;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;

public class JaxbSample {

    public static void main(String args[]) throws JAXBException
    {
        // Create an account
        BrokerageAccount account =
            new BrokerageAccount(1000L, "John's Brokerage Account", 1000.00);
        Order order = new Order(101L, "Buy", "GOOG", 1000);
        account.addOrder(order);
 
        // Write it out as XML
        JAXBContext jaxbContext = JAXBContext.newInstance(BrokerageAccount.class);
        StringWriter writer = new StringWriter();
        Marshaller marshaller = jaxbContext.createMarshaller();
        marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
        marshaller.marshal(account, writer);
        String accountString = writer.toString();

        System.out.println("\nOriginal Account");
        System.out.println(accountString);
        System.out.println("\nOriginal Order:");
        System.out.println(order);

        // Read it from XML
        BrokerageAccount accountRead =
            (BrokerageAccount)jaxbContext.createUnmarshaller().unmarshal(
                new StringReader(accountString));
        Order orderRead = accountRead.getOrders().iterator().next();

        // Write it out as XML again
        writer = new StringWriter();
        marshaller.marshal(accountRead, writer);
        String accountReadString = writer.toString();

        System.out.println("\nRead Account");
        System.out.println(accountReadString);
        System.out.println("\nRead Order:");
        System.out.println(orderRead);
    }
}