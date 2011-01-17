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
package org.archfirst.bfoms.domain.account.external;

import javax.persistence.Entity;
import javax.persistence.Transient;

import org.archfirst.bfoms.domain.account.AccountStatus;
import org.archfirst.bfoms.domain.account.BaseAccount;
import org.archfirst.bfoms.domain.account.CashTransfer;
import org.archfirst.bfoms.domain.account.SecuritiesTransfer;
import org.archfirst.bfoms.domain.pricing.Instrument;
import org.archfirst.bfoms.domain.pricing.PricingService;
import org.archfirst.common.money.Money;
import org.archfirst.common.quantity.DecimalQuantity;

/**
 * ExternalAccount
 *
 * @author Naresh Bhatia
 */
@Entity
public class ExternalAccount extends BaseAccount {
    private static final long serialVersionUID = 1L;
    
    private String routingNumber;
    private String accountNumber;

    // ----- Constructors -----
    private ExternalAccount() {
    }

    // Allow access only from AccountFactory
    ExternalAccount(String name, AccountStatus status,
            String routingNumber, String accountNumber) {
        super(name, status);
        this.routingNumber = routingNumber;
        this.accountNumber = accountNumber;
    }

    // ----- Commands -----
    @Override
    public void transferCash(CashTransfer transfer) {
        this.addTransaction(transfer);
    }
    
    @Override
    public void transferSecurities(SecuritiesTransfer transfer) {
        this.addTransaction(transfer);
    }

    // ----- Queries and Read-Only Operations -----
    @Override
    public boolean isCashAvailable(
            Money amount,
            PricingService pricingService) {
        // Let external agency worry about whether the cash is available
        return true;
    }

    @Override
    public boolean isSecurityAvailable(
            Instrument instrument,
            DecimalQuantity quantity) {
        // Let external agency worry about whether the security is available
        return true;
    }

    @Transient
    public String getDisplayString() {
        return toString();
    }

    @Override
    public String toString() {
        StringBuilder builder = new StringBuilder();
        builder.append(name).append(" - ");
        builder.append(accountNumber).append(" (External)");
        return builder.toString();
    }

    // ----- Getters and Setters -----
    public String getRoutingNumber() {
        return routingNumber;
    }
    private void setRoutingNumber(String routingNumber) {
        this.routingNumber = routingNumber;
    }

    public String getAccountNumber() {
        return accountNumber;
    }
    private void setAccountNumber(String accountNumber) {
        this.accountNumber = accountNumber;
    }
}