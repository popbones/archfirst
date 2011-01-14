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

import org.archfirst.bfoms.domain.util.Constants;
import org.archfirst.common.money.Money;
import org.joda.time.DateTime;

/**
 * CashTransfer
 *
 * @author Naresh Bhatia
 */
@Entity
public class CashTransfer extends Transaction {
    private static final long serialVersionUID = 1L;

    private static final String TYPE = "Transfer";

    private Money amount;
    private BaseAccount otherAccount;
    
    // ----- Constructors -----
    protected CashTransfer() {
    }

    public CashTransfer(
            DateTime creationTime,
            Money amount,
            BaseAccount otherAccount) {
        super(creationTime);
        this.amount = amount;
        this.otherAccount = otherAccount;
    }

    // ----- Getters and Setters -----
    @Override
    @Transient
    public String getType() {
        return TYPE;
    }

    @Embedded
    @AttributeOverrides({
        @AttributeOverride(name="amount",
            column = @Column(
                    name="amount",
                    precision=Constants.MONEY_PRECISION,
                    scale=Constants.MONEY_SCALE)),
        @AttributeOverride(name="currency",
            column = @Column(
                    name="currency",
                    length=Money.CURRENCY_LENGTH))
     })
    public Money getAmount() {
        return amount;
    }
    private void setAmount(Money amount) {
        this.amount = amount;
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
        builder.append(amount.isPlus() ? "from " : "to ");
        builder.append(otherAccount.getName());
        return builder.toString();
    }
}