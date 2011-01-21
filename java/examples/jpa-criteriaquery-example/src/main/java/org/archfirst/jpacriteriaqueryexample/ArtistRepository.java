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

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Path;
import javax.persistence.criteria.Root;

import org.springframework.stereotype.Repository;

/**
 * ArtistRepository
 *
 * @author Naresh Bhatia
 */
@Repository
public class ArtistRepository {
    
    @PersistenceContext
    protected EntityManager entityManager;
    
    public void createArtist(Artist artist) {
        entityManager.persist(artist);
    }
    
    public void addTitle(Long artistId, Title title) {
        entityManager.persist(title);
        entityManager.flush();
        Artist artist = entityManager.find(Artist.class, artistId);
        artist.addTitle(title);        
    }
    
    public List<Title> getTitles(Long artistId) {
        CriteriaBuilder builder = entityManager.getCriteriaBuilder();
        CriteriaQuery<Title> query = builder.createQuery(Title.class);

        // select * from Transaction
        Root<Title> _title = query.from(Title.class);
        
        // where artistId = artistId passed in
        Path<Artist> _artist = _title.get(Title_.artist);
        Path<Long> _artistId = _artist.get(Artist_.id);
        query.where(builder.equal(_artistId, artistId));
       
        // Execute the query
        return entityManager.createQuery(query).getResultList();
    }
}