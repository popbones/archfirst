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
package org.archfirst.bfexch.domain.referencedata;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Transient;
import javax.validation.constraints.NotNull;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

/**
 * Instrument
 *
 * @author Naresh Bhatia
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "Instrument")
@Entity
public class Instrument implements Comparable <Instrument> {
    private static final long serialVersionUID = 1L;

    @XmlElement(name = "Symbol", required = true)
    @Id
    private String symbol;

    @XmlElement(name = "Name", required = true)
    private String name;

    @XmlElement(name = "Exchange", required = true)
    private String exchange;

    // ----- Constructors -----
    public Instrument() {
    }

    public Instrument(String symbol, String name, String exchange) {
        this.symbol = symbol;
        this.name = name;
        this.exchange = exchange;
    }

    // ----- Queries and Read-Only Operations -----
    @Override
    public boolean equals(Object object) {
        if (this == object) {
            return true;
        }
        if (!(object instanceof Instrument)) {
            return false;
        }
        final Instrument that = (Instrument)object;
        return this.symbol.equals(that.getSymbol());
    }

    @Override
    public int hashCode() {
        return symbol.hashCode();
    }

    @Override
    public int compareTo(Instrument other) {
        return this.symbol.compareTo(other.getSymbol());
    }

    @Transient
    public String getDisplayString() {
        StringBuilder builder = new StringBuilder();
        builder.append(symbol);
        builder.append(" - ");
        builder.append(name);
        return builder.toString();
    }

    @Override
    public String toString() {
        return symbol;
    }

    // ----- Getters and Setters -----
    @NotNull
    public String getSymbol() {
        return symbol;
    }
    private void setSymbol(String symbol) {
        this.symbol = symbol;
    }

    public String getName() {
        return name;
    }
    private void setName(String name) {
        this.name = name;
    }

    public String getExchange() {
        return exchange;
    }
    private void setExchange(String exchange) {
        this.exchange = exchange;
    }
}