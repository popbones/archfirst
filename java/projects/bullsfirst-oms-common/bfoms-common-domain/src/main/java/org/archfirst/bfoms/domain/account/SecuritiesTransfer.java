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

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.ManyToOne;
import javax.persistence.Transient;
import javax.validation.constraints.NotNull;

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
public class SecuritiesTransfer extends Transaction {
    private static final long serialVersionUID = 1L;

    private static final String TYPE = "Transfer";

    private Instrument instrument;
    private DecimalQuantity quantity;
    private Money pricePaidPerShare;
    private BaseAccount otherAccount;

    // ----- Constructors -----
    protected SecuritiesTransfer() {
    }

    public SecuritiesTransfer(
            DateTime creationTime,
            Instrument instrument,
            DecimalQuantity quantity,
            Money pricePaidPerShare,
            BaseAccount otherAccount) {
        super(creationTime);
        this.instrument = instrument;
        this.quantity = quantity;
        this.otherAccount = otherAccount;
    }

    // ----- Getters and Setters -----
    @Override
    @Transient
    public String getType() {
        return TYPE;
    }

    @Override
    @Transient
    public Money getAmount() {
        // A securities transfer does not involve money
        return new Money("0.00");
    }

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

    @Embedded
    @AttributeOverrides({
        @AttributeOverride(name="amount",
            column = @Column(
                    name="price_paid_amount",
                    precision=Constants.MONEY_PRECISION,
                    scale=Constants.MONEY_SCALE)),
        @AttributeOverride(name="currency",
            column = @Column(
                    name="price_paid_currency",
                    length=Money.CURRENCY_LENGTH))
     })
    public Money getPricePaidPerShare() {
        return pricePaidPerShare;
    }
    public void setPricePaidPerShare(Money pricePaidPerShare) {
        this.pricePaidPerShare = pricePaidPerShare;
    }

    @NotNull
    @ManyToOne
    public BaseAccount getOtherAccount() {
        return otherAccount;
    }
    private void setOtherAccount(BaseAccount otherAccount) {
        this.otherAccount = otherAccount;
    }

    @Override
    @Transient
    public String getDescription() {
        StringBuilder builder = new StringBuilder();
        builder.append("Transfer ");
        builder.append(quantity.abs()).append(" shares of ").append(instrument);
        builder.append(quantity.isPlus() ? " from " : " to ");
        builder.append(otherAccount.getName());
        return builder.toString();
    }
}