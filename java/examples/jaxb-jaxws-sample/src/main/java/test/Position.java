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
package test;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

/**
 * Position
 *
 * @author Naresh Bhatia
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "Position")
@XmlRootElement(name = "Position")
public class Position {

    @XmlElement(name = "Quantity", required = true)
    private DecimalQuantity quantity;

    // ----- Constructors -----
    public Position() {
    }

    public Position(DecimalQuantity quantity) {
        this.quantity = quantity;
    }

    // ----- Getters -----
    public DecimalQuantity getQuantity() {
        return quantity;
    }
}