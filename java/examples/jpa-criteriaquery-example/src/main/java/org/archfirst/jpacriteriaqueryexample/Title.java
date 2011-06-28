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

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlTransient;

/**
 * Title
 *
 * @author Naresh Bhatia
 */
@Entity
@XmlAccessorType(XmlAccessType.FIELD)
public class Title {

    // ----- Constructors -----
    public Title() {
    }

    public Title(String name, int released) {
        this.name = name;
        this.released = released;
    }

    // ----- Commands -----

    // ----- Queries -----
    @Override
    public String toString() {
        return name + " (" + released + ")";
    }

    // ----- Attributes -----
    @Id
    @GeneratedValue
    @XmlAttribute(name = "Id")
    private Long id;

    @Column(nullable = false)
    @XmlAttribute(name = "Name")
    private String name;

    @Column(nullable = false)
    @XmlAttribute(name = "Released")
    private int released;

    @ManyToOne
    @XmlTransient
    private Artist artist;

    // ----- Getters -----
    public Long getId() {
        return id;
    }
    public String getName() {
        return name;
    }
    public int getReleased() {
        return released;
    }
    public Artist getArtist() {
        return artist;
    }

    // ----- Setters -----
    // Allow access to artist
    void setArtist(Artist artist) {
        this.artist = artist;
    }
}