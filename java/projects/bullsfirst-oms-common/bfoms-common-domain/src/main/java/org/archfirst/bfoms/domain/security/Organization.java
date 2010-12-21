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
package org.archfirst.bfoms.domain.security;

import javax.persistence.Entity;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;

/**
 * Organization
 *
 * @author Naresh Bhatia
 */
@XmlAccessorType(XmlAccessType.FIELD)
@Entity
public class Organization extends Party {
    private static final long serialVersionUID = 1L; 

    @XmlElement(name = "Name")
    private String name;

    // ----- Constructors -----
    private Organization() {
    }
    
    public Organization(String name) {
        this.name = name;
    }

    // ----- Queries and Read-Only Operations -----
    @Override
    public boolean equals(Object object) {
        if (this == object) {
            return true;
        }
        if (!(object instanceof Organization)) {
            return false;
        }
        final Organization that = (Organization)object;
        return this.name.equals(that.getName());
    }

    @Override
    public int hashCode() {
        return name.hashCode();
    }

    // ----- Getters and Setters -----
    public String getName() {
        return name;
    }
    private void setName(String name) {
        this.name = name;
    }
}