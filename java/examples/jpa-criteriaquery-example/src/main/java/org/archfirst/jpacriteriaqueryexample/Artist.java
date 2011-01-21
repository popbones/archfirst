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
import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToMany;

/**
 * Artist
 *
 * @author Naresh Bhatia
 */
@Entity
public class Artist {
    private Long id;
    private String name;
    private String genre;
    private Calendar born;
    private Calendar died;
    private Set<Title> titles = new HashSet<Title>();

    // ----- Constructors -----
    public Artist() {
    }

    public Artist(String name, String genre, Calendar born, Calendar died) {
        this.name = name;
        this.genre = genre;
        this.born = born;
        this.died = died;
    }

    // ----- Getters and Setters -----
    @Id
    @GeneratedValue
    public Long getId() {
        return id;
    }
    public void setId(Long id) {
        this.id = id;
    }

    @Column(nullable = false)
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }

    @Column(nullable = false)
    public String getGenre() {
        return genre;
    }
    public void setGenre(String genre) {
        this.genre = genre;
    }

    @Column(nullable = false)
    public Calendar getBorn() {
        return born;
    }
    public void setBorn(Calendar born) {
        this.born = born;
    }

    @Column(nullable = true)
    public Calendar getDied() {
        return died;
    }
    public void setDied(Calendar died) {
        this.died = died;
    }

    @OneToMany(mappedBy="artist",  cascade=CascadeType.ALL)
    public Set<Title> getTitles() {
        return titles;
    }
    public void setTitles(Set<Title> titles) {
        this.titles = titles;
    }
    public void addTitle(Title title) {
        this.titles.add(title);
        title.setArtist(this);
    }
}