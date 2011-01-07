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

import static javax.persistence.InheritanceType.JOINED;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Inheritance;
import javax.persistence.OneToMany;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;

import org.archfirst.bfoms.domain.account.brokerage.Allocatable;
import org.archfirst.bfoms.domain.account.brokerage.BrokerageAccountRepository;
import org.archfirst.bfoms.domain.pricing.Instrument;
import org.archfirst.bfoms.domain.pricing.PricingService;
import org.archfirst.bfoms.domain.util.Constants;
import org.archfirst.common.domain.DomainEntity;
import org.archfirst.common.money.Money;
import org.archfirst.common.quantity.DecimalQuantity;
import org.hibernate.annotations.Parameter;
import org.hibernate.annotations.Type;
import org.joda.time.DateTime;

/**
 * BaseAccount
 *
 * @author Naresh Bhatia
 */
@XmlAccessorType(XmlAccessType.FIELD)
@Entity
@Inheritance(strategy=JOINED)
public abstract class BaseAccount extends DomainEntity {
    private static final long serialVersionUID = 1L;

    private static final int MIN_LENGTH = 3;
    private static final int MAX_LENGTH = 50;

    protected String name;
    protected AccountStatus status = AccountStatus.Active;
    protected Set<AccountParty> accountParties = new HashSet<AccountParty>();
    protected Set<Transaction> transactions = new HashSet<Transaction>();

    // ----- Constructors -----
    protected BaseAccount() {
    }

    protected BaseAccount(String name, AccountStatus status) {
        this.name = name;
        this.status = status;
    }

    // ----- Commands -----
    public void changeName(String newName) {
        this.name = newName;
    }
    
    protected abstract void deposit(Money amount);

    /**
     * Withdraw will allow overdrawing of the account. Any checking of
     * available cash must be done by the caller based on the use case.
     * @param amount
     */
    protected abstract void withdraw(Money amount);

    public void transferSecurities(
            Instrument instrument,
            DecimalQuantity quantity,
            Money pricePaidPerShare,
            BaseAccount toAccount,
            BrokerageAccountRepository accountRepository) {
        DateTime now = new DateTime();
        SecuritiesTransfer withdrawal = new SecuritiesTransfer(
                now,
                toAccount,
                instrument,
                quantity.negate());
        SecuritiesTransfer deposit = new SecuritiesTransfer(
                now,
                this,
                instrument,
                quantity);
        this.withdraw(instrument, quantity, withdrawal, accountRepository);
        toAccount.deposit(instrument, quantity, pricePaidPerShare, deposit, accountRepository);
        this.addTransaction(withdrawal);
        toAccount.addTransaction(deposit);
    }

    protected abstract void deposit(
            Instrument instrument,
            DecimalQuantity quantity,
            Money pricePaidPerShare,
            Allocatable allocatable,
            BrokerageAccountRepository accountRepository);

    /**
     * Withdraw will allow overdrawing of the account. Any checking of
     * available securities must be done by the caller based on the use case.
     * @param instrument
     * @param quantity
     * @param allocatable
     * @param accountRepository
     */
    protected abstract void withdraw(
            Instrument instrument,
            DecimalQuantity quantity,
            Allocatable allocatable,
            BrokerageAccountRepository accountRepository);

    // ----- Queries and Read-Only Operations -----
    public abstract boolean isCashAvailable(
            Money amount,
            BrokerageAccountRepository accountRepository,
            PricingService pricingService);

    public abstract boolean isSecurityAvailable(
            Instrument instrument,
            DecimalQuantity quantity,
            BrokerageAccountRepository accountRepository);

    // ----- Getters and Setters -----
    @NotNull
    @Size(min = MIN_LENGTH, max = MAX_LENGTH)
    @Column(nullable = false)
    public String getName() {
        return name;
    }
    private void setName(String name) {
        this.name = name;
    }

    @Type(
        type = "org.archfirst.common.hibernate.GenericEnumUserType",
        parameters = {
            @Parameter (
                name  = "enumClass",
                value = "org.archfirst.bfoms.domain.trading.AccountStatus")
            }
    )
    @Column(length=Constants.ENUM_COLUMN_LENGTH)
    public AccountStatus getStatus() {
        return status;
    }
    private void setStatus(AccountStatus status) {
        this.status = status;
    }
    
    // CollectionOfElements does not cascade - this is a hibernate bug
    // (see http://opensource.atlassian.com/projects/hibernate/browse/ANN-755)
    // So we have to treat AccountParties as entities instead of value objects
    // @CollectionOfElements(targetElement = AccountParty.class)
    // @JoinTable(name = "Account_AccountParties",
    //    joinColumns = @JoinColumn(name = "account_id"))
    @OneToMany(mappedBy="account",  cascade=CascadeType.ALL)
    public Set<AccountParty> getAccountParties() {
        return accountParties;
    }
    private void setAccountParties(Set<AccountParty> accountParties) {
        this.accountParties = accountParties;
    }

    // Allow access from AccountFactory
    void addAccountParty(
            AccountParty accountParty,
            BrokerageAccountRepository accountRepository) {
        accountParty.setAccount(this);
        accountRepository.persist(accountParty);
        accountRepository.flush(); // get party id before adding to set
        accountParties.add(accountParty);
    }

    @OneToMany(mappedBy="account",  cascade=CascadeType.ALL)
    public Set<Transaction> getTransactions() {
        return transactions;
    }
    private void setTransactions(Set<Transaction> transactions) {
        this.transactions = transactions;
    }

    protected void addTransaction(Transaction transaction) {
        transaction.setAccount(this);
        transactions.add(transaction);
    }
}