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
package org.archfirst.bfoms.domain.account;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Transient;
import javax.validation.constraints.NotNull;

import org.archfirst.bfoms.domain.account.brokerage.Allocatable;
import org.archfirst.bfoms.domain.account.brokerage.Lot;
import org.archfirst.bfoms.domain.account.brokerage.TransferAllocation;
import org.archfirst.bfoms.domain.pricing.Instrument;
import org.archfirst.bfoms.domain.util.Constants;
import org.archfirst.common.money.Money;
import org.archfirst.common.quantity.DecimalQuantity;
import org.joda.time.DateTime;

/**
 * SecuritiesTransfer
 *
 * @author Naresh Bhatia
 */
@Entity
public class SecuritiesTransfer extends Transfer implements Allocatable {
    private static final long serialVersionUID = 1L;

    private Instrument instrument;
    private DecimalQuantity quantity;
    private Set<TransferAllocation> allocations = new HashSet<TransferAllocation>();

    // ----- Constructors -----
    protected SecuritiesTransfer() {
    }

    public SecuritiesTransfer(
            DateTime creationTime,
            BaseAccount otherAccount,
            Instrument instrument,
            DecimalQuantity quantity) {
        super(creationTime, otherAccount);
        this.instrument = instrument;
        this.quantity = quantity;
    }

    // ----- Commands -----
    @Override
    public void allocate(DecimalQuantity quantity, Lot lot) {
        this.addAllocation(new TransferAllocation(quantity, lot));
    }

    private void addAllocation(TransferAllocation allocation) {
        allocations.add(allocation);
        allocation.setTransfer(this);
    }

    // ----- Getters and Setters -----
    @NotNull
    @ManyToOne
    public Instrument getInstrument() {
        return instrument;
    }
    private void setInstrument(Instrument instrument) {
        this.instrument = instrument;
    }

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

    @OneToMany(mappedBy="transfer", cascade=CascadeType.ALL)
    public Set<TransferAllocation> getAllocations() {
        return allocations;
    }
    private void setAllocations(Set<TransferAllocation> allocations) {
        this.allocations = allocations;
    }

    @Override
    @Transient
    public String getDescription() {
        StringBuilder builder = new StringBuilder();
        builder.append("Transfer ");
        builder.append(quantity.abs()).append(" shares of ").append(instrument);
        builder.append(quantity.isPlus() ? " from " : " to ");
        builder.append(getOtherAccount().getName());
        return builder.toString();
    }

    @Override
    @Transient
    public Money getAmount() {
        // A securities transfer does not involve money
        return new Money("0.00");
    }
}