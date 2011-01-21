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
package org.archfirst.jpacriteriaqueryexample;

import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.testng.AbstractTransactionalTestNGSpringContextTests;
import org.testng.Assert;
import org.testng.annotations.Test;

@ContextConfiguration(locations={"classpath:/org/archfirst/jpacriteriaqueryexample/applicationContext.xml"})
public class JpaCriteriaQueryTest extends AbstractTransactionalTestNGSpringContextTests {
    private static final Logger logger =
        LoggerFactory.getLogger(JpaCriteriaQueryTest.class);
    
    @Autowired
    private ArtistRepository artistRepository;

    @Test
    public void testGetTitles()
    {
        // Create an artist
        Artist artist = new Artist(
                "Michael Jackson",
                "Pop",
                new GregorianCalendar(1958, Calendar.AUGUST, 29),
                new GregorianCalendar(2009, Calendar.JUNE, 25));
        artistRepository.createArtist(artist);
        Long artistId = artist.getId();

        // Add titles
        artistRepository.addTitle(artistId, new Title("Billie Jean", 1983));
        artistRepository.addTitle(artistId, new Title("Beat It", 1983));
        artistRepository.addTitle(artistId, new Title("Thriller", 1984));

        // Get titles for artist
        List<Title> titles = artistRepository.getTitles(artistId);
        Assert.assertEquals(titles.size(), 3);
        
        logger.debug("******************************");
        logger.debug("Titles for artist {}:", artistId);
        for (Title title : titles) {
            logger.debug(title.toString());
        }
        logger.debug("******************************");
    }
}