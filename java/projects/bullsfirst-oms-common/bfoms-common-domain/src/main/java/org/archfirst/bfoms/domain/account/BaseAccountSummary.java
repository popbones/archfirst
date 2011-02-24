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
package org.archfirst.bfoms.domain.account;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

/**
 * BaseAccountSummary
 *
 * @author Naresh Bhatia
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "BaseAccountSummary")
public abstract class BaseAccountSummary {

    @XmlElement(name = "Id")
    protected long id;
    @XmlElement(name = "Name", required = true)
    protected String name;

    // ----- Constructors -----
    public BaseAccountSummary() {
    }

    public BaseAccountSummary(
            long id,
            String name) {
        this.id = id;
        this.name = name;
    }

    // ----- Getters and Setters -----
    public long getId() {
        return id;
    }
    public void setId(long value) {
        this.id = value;
    }

    public String getName() {
        return name;
    }
    public void setName(String value) {
        this.name = value;
    }
}