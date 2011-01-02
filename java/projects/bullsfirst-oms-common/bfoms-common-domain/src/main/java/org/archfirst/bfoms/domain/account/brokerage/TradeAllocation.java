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
package org.archfirst.bfoms.domain.account.brokerage;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.ManyToOne;
import javax.validation.constraints.NotNull;

import org.archfirst.bfoms.domain.util.Constants;
import org.archfirst.common.domain.DomainEntity;
import org.archfirst.common.quantity.DecimalQuantity;

/**
 * TradeAllocation
 *
 * @author Naresh Bhatia
 */
@Entity
public class TradeAllocation extends DomainEntity {
    private static final long serialVersionUID = 1L;

    private DecimalQuantity quantity;
    private Trade trade;
    private Lot lot;

    // ----- Constructors -----
    private TradeAllocation() {
    }

    // Allow access to Trade
    TradeAllocation(DecimalQuantity quantity, Lot lot) {
        this.quantity = quantity;
        this.lot = lot;
    }

    // ----- Queries and Read-Only Operations -----
    @Override
    public boolean equals(Object object) {
        if (this == object) {
            return true;
        }
        if (!(object instanceof TradeAllocation)) {
            return false;
        }
        final TradeAllocation that = (TradeAllocation)object;
        // Lot id's should be unique across a trade
        return this.lot.getId().equals(that.getLot().getId());
    }

    @Override
    public int hashCode() {
        return this.lot.getId().hashCode();
    }

    // ----- Getters and Setters -----
    @NotNull
    @Embedded
    @AttributeOverrides({
        @AttributeOverride(name="value",
            column = @Column(
                    name="quantity",
                    precision=Constants.QUANTITY_PRECISION,
                    scale=Constants.QUANTITY_SCALE))})
    public DecimalQuantity getQuantity() {
        return quantity;
    }
    private void setQuantity(DecimalQuantity quantity) {
        this.quantity = quantity;
    }

    @ManyToOne
    public Trade getTrade() {
        return trade;
    }
    // Allow access to Trade
    void setTrade(Trade trade) {
        this.trade = trade;
    }

    @ManyToOne
    public Lot getLot() {
        return lot;
    }
    private void setLot(Lot lot) {
        this.lot = lot;
    }
}