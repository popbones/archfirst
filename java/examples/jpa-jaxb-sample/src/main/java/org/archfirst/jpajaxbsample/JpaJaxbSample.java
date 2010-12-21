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
package org.archfirst.jpajaxbsample;

import java.io.StringWriter;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;

import org.archfirst.bfoms.domain.security.User;

public class JpaJaxbSample {

    public static void main(String args[]) throws JAXBException
    {
        // Create an EntityManager
        EntityManagerFactory emf =
            javax.persistence.Persistence.createEntityManagerFactory("bfoms");
        EntityManager em = emf.createEntityManager();

        // Read a user from database
        em.getTransaction().begin();

        User user = em.find(User.class, 1L);
        JAXBContext jaxbContext = JAXBContext.newInstance(User.class);
        StringWriter writer = new StringWriter();
        Marshaller marshaller = jaxbContext.createMarshaller();
        marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
        marshaller.marshal(user, writer);
        String userString = writer.toString();

        em.getTransaction().commit();

        // Write it out as XML
        System.out.println(userString);
    }
}