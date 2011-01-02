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
package org.archfirst.bfoms.domain.account.transaction;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.ManyToOne;
import javax.validation.constraints.NotNull;

import org.archfirst.bfoms.domain.account.brokerage.Lot;
import org.archfirst.bfoms.domain.util.Constants;
import org.archfirst.common.domain.DomainEntity;
import org.archfirst.common.quantity.DecimalQuantity;

/**
 * TransferAllocation
 *
 * @author Naresh Bhatia
 */
@Entity
public class TransferAllocation extends DomainEntity {
    private static final long serialVersionUID = 1L;

    private DecimalQuantity quantity;
    private SecuritiesTransfer transfer;
    private Lot lot;

    // ----- Constructors -----
    private TransferAllocation() {
    }

    // Allow access to SecuritiesTransfer
    TransferAllocation(DecimalQuantity quantity, Lot lot) {
        this.quantity = quantity;
        this.lot = lot;
    }

    // ----- Queries and Read-Only Operations -----
    @Override
    public boolean equals(Object object) {
        if (this == object) {
            return true;
        }
        if (!(object instanceof TransferAllocation)) {
            return false;
        }
        final TransferAllocation that = (TransferAllocation)object;
        // Lot id's should be unique across a transfer
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
    public SecuritiesTransfer getTransfer() {
        return transfer;
    }
    // Allow access to SecuritiesTransfer
    void setTransfer(SecuritiesTransfer transfer) {
        this.transfer = transfer;
    }

    @ManyToOne
    public Lot getLot() {
        return lot;
    }
    private void setLot(Lot lot) {
        this.lot = lot;
    }
}