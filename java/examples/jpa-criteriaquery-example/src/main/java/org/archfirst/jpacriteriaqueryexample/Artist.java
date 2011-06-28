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
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * Artist
 *
 * @author Naresh Bhatia
 */
@Entity
@XmlAccessorType(XmlAccessType.FIELD)
@XmlRootElement(name = "Artist")
public class Artist {

    // ----- Constructors -----
    public Artist() {
    }

    public Artist(String name, String genre, Calendar born, Calendar died) {
        this.name = name;
        this.genre = genre;
        this.born = born;
        this.died = died;
    }

    // ----- Commands -----
    public void addTitle(Title title) {
        this.titles.add(title);
        title.setArtist(this);
    }

    // ----- Queries -----

    // ----- Attributes -----
    @Id
    @GeneratedValue
    @XmlAttribute(name = "Id")
    private Long id;

    @Column(nullable = false)
    @XmlAttribute(name = "Name")
    private String name;

    @Column(nullable = false)
    @XmlAttribute(name = "Genre")
    private String genre;

    @Column(nullable = false)
    @XmlAttribute(name = "Born")
    private Calendar born;

    @Column(nullable = true)
    @XmlAttribute(name = "Died")
    private Calendar died;

    @OneToMany(mappedBy="artist",  cascade=CascadeType.ALL)
    @XmlElement(name = "Title")
    private Set<Title> titles = new HashSet<Title>();

    // ----- Getters -----
    public Long getId() {
        return id;
    }
    public String getName() {
        return name;
    }
    public String getGenre() {
        return genre;
    }
    public Calendar getBorn() {
        return born;
    }
    public Calendar getDied() {
        return died;
    }
    public Set<Title> getTitles() {
        return titles;
    }
}