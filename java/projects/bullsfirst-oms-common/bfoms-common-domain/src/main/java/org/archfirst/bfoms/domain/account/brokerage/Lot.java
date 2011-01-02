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

import org.archfirst.bfoms.domain.account.position.LotPosition;
import org.archfirst.bfoms.domain.account.position.Position;
import org.archfirst.bfoms.domain.pricing.Instrument;
import org.archfirst.bfoms.domain.pricing.PricingService;
import org.archfirst.bfoms.domain.util.Constants;
import org.archfirst.common.domain.DomainEntity;
import org.archfirst.common.money.Money;
import org.archfirst.common.quantity.DecimalQuantity;
import org.hibernate.annotations.Type;
import org.joda.time.DateTime;

/**
 * Lot
 *
 * @author Naresh Bhatia
 */
@Entity
public class Lot extends DomainEntity {
    private static final long serialVersionUID = 1L;
    
    private DateTime creationTime;
    private Instrument instrument;
    private DecimalQuantity quantity;
    private Money pricePaidPerShare;
    private BrokerageAccount account;

    // ----- Constructors -----
    private Lot() {
    }
    
    // Allow access only from AccountFactory
    Lot(
            DateTime creationTime,
            Instrument instrument,
            DecimalQuantity quantity,
            Money pricePaidPerShare) {
        this.creationTime = creationTime;
        this.instrument = instrument;
        this.quantity = quantity;
        this.pricePaidPerShare = pricePaidPerShare;
    }

    // ----- Factories -----
    // Allow access only from Account
    Position assemblePosition(PricingService pricingService) {
        return new LotPosition(
                id,
                creationTime,
                instrument.getName(),
                instrument.getSymbol(),
                quantity,
                pricingService.getMarketPrice(instrument),
                pricePaidPerShare);
    }
    
    // ----- Commands -----
    // Allow access only from Account
    void buy(DecimalQuantity quantityToBuy, Money pricePaidPerShare) {
        quantity = quantity.plus(quantityToBuy);
        this.pricePaidPerShare = pricePaidPerShare;
    }

    // Allow access only from Account
    void sell(DecimalQuantity quantityToSell) {
        quantity = quantity.minus(quantityToSell);
    }

    // ----- Queries and Read-Only Operations -----

    // ----- Getters and Setters -----
    @Type(type = "org.joda.time.contrib.hibernate.PersistentDateTime")
    @Column(nullable = false)
    public DateTime getCreationTime() {
        return creationTime;
    }
    private void setCreationTime(DateTime creationTime) {
        this.creationTime = creationTime;
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
                    precision=Constants.PRICE_PRECISION,
                    scale=Constants.PRICE_SCALE)),
        @AttributeOverride(name="currency",
            column = @Column(
                    name="price_paid_currency",
                    length=Money.CURRENCY_LENGTH))
     })
    public Money getPricePaidPerShare() {
        return pricePaidPerShare;
    }
    private void setPricePaidPerShare(Money pricePaidPerShare) {
        this.pricePaidPerShare = pricePaidPerShare;
    }

    @ManyToOne
    public BrokerageAccount getAccount() {
        return account;
    }
    // Allow access only from AccountFactory
    void setAccount(BrokerageAccount account) {
        this.account = account;
    }
}