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
package org.archfirst.bfoms.domain.account.position;

import java.util.List;

import org.archfirst.common.datetime.DateTimeUtil;
import org.archfirst.common.money.Money;
import org.archfirst.common.quantity.DecimalQuantity;
import org.archfirst.common.quantity.Percentage;
import org.joda.time.DateTime;

/**
 * Position
 *
 * @author Naresh Bhatia
 */
public abstract class Position {
    protected Long id;
    protected DateTime creationTime;
    protected String name;
    protected String symbol;
    protected DecimalQuantity quantity;
    protected Money lastTrade;
    protected Money marketValue;
    protected Money pricePaid;
    protected Money totalCost;
    protected Money gain;
    protected Percentage gainPercent;
    protected List<Position> children;

    // ----- Commands -----
    public void addChild(Position position) {
        this.children.add(position);
    }
    
    /**
     * Abstract method that calculates the position based on
     * other attributes and/or child positions.
     */
    public abstract void calculate();
    
    // ----- Queries and Read-Only Operations -----
    @Override
    public String toString() {
        StringBuilder builder = new StringBuilder();
        builder.append(getType());
        if (creationTime != null) {
            builder.append(": creationTime=").append(DateTimeUtil.toStringTimestamp(creationTime)).append(",");
        }
        builder.append("name=").append(name);
        builder.append(", symbol=").append(symbol);
        builder.append(", quantity=").append(quantity);
        builder.append(", lastTrade=").append(lastTrade);
        builder.append(", marketValue=").append(marketValue);
        builder.append(", pricePaid=").append(pricePaid);
        builder.append(", totalCost=").append(totalCost);
        builder.append(", gain=").append(gain);
        builder.append(", gainPercent=").append(gainPercent);
        return builder.toString();
    }
    
    public String toStringDeep() {
        return toStringDeep(0);
    }

    private String toStringDeep(int indent) {
        // Print self
        StringBuilder builder = new StringBuilder();
        for (int i=0; i<indent; i++) {
            builder.append(" ");
        }
        builder.append(this);

        // Print children
        if (children != null) {
            for (Position child : children) {
                builder.append("\n").append(child.toStringDeep(indent+2));
            }
        }

        return builder.toString();
    }

    // ----- Getters -----
    public Long getId() {
        return id;
    }
    public DateTime getCreationTime() {
        return creationTime;
    }
    public String getName() {
        return name;
    }
    public String getSymbol() {
        return symbol;
    }
    public DecimalQuantity getQuantity() {
        return quantity;
    }
    public Money getLastTrade() {
        return lastTrade;
    }
    public Money getMarketValue() {
        return marketValue;
    }
    public Money getPricePaid() {
        return pricePaid;
    }
    public Money getTotalCost() {
        return totalCost;
    }
    public Money getGain() {
        return gain;
    }
    public Percentage getGainPercent() {
        return gainPercent;
    }
    public List<Position> getChildren() {
        return children;
    }
    
    public abstract String getType();
}