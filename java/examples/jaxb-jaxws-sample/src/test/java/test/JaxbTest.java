/**
 * Copyright 2011 Archfirst
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
package test;

import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.testng.Assert;
import org.testng.annotations.Test;

/**
 * Proj3Test
 * 
 * @author Naresh Bhatia
 */
public class JaxbTest {
    private static final Logger logger = LoggerFactory
            .getLogger(JaxbTest.class);

    @Test
    public void testMarshalUnmarshal() throws JAXBException, IOException {

        // Create a Position
        Position position = new Position(new DecimalQuantity("10.2"));

        // Write it out as XML
        JAXBContext jaxbContext = JAXBContext.newInstance(Position.class);
        StringWriter writer = new StringWriter();
        Marshaller marshaller = jaxbContext.createMarshaller();
        marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
        marshaller.marshal(position, writer);
        String positionString = writer.toString();
        logger.debug("Position converted to XML:\n" + positionString);

        // Write out the schema (for debugging purposes)
        jaxbContext.generateSchema(new DefaultSchemaOutputResolver("target"));

        // Read it from XML
        Position positionRead = (Position) jaxbContext
                .createUnmarshaller()
                .unmarshal(new StringReader(positionString));

        // Compare quantities
        Assert.assertEquals(positionRead.getQuantity(), position.getQuantity());

    }
}