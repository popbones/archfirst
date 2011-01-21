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

/**
 * Title
 *
 * @author Naresh Bhatia
 */
@Entity
public class Title {
    private Long id;
    private String name;
    private int released;
    private Artist artist;

    // ----- Constructors -----
    public Title() {
    }

    public Title(String name, int released) {
        this.name = name;
        this.released = released;
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
    public int getReleased() {
        return released;
    }
    public void setReleased(int released) {
        this.released = released;
    }

    @ManyToOne
    public Artist getArtist() {
        return artist;
    }
    public void setArtist(Artist artist) {
        this.artist = artist;
    }

    @Override
    public String toString() {
        return name + " (" + released + ")";
    }
}