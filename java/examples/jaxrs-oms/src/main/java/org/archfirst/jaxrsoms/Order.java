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
package org.archfirst.jaxrsoms;

import java.net.URI;

/**
 * Order
 *
 * @author Naresh Bhatia
 */
public class Order {

    // ----- Constructors -----
    public Order() {
    }

    public Order(String side, String symbol, int quantity) {
        this.side = side;
        this.symbol = symbol;
        this.quantity = quantity;
    }

    // ----- Attributes -----
    private int id;
    private String side;
    private String symbol;
    private int quantity;
    private URI self;

    // ----- Getters and Setters -----
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public String getSide() {
        return side;
    }
    public void setSide(String side) {
        this.side = side;
    }
    public String getSymbol() {
        return symbol;
    }
    public void setSymbol(String symbol) {
        this.symbol = symbol;
    }
    public int getQuantity() {
        return quantity;
    }
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    public URI getSelf() {
        return self;
    }
    public void setSelf(URI self) {
        this.self = self;
    }
}