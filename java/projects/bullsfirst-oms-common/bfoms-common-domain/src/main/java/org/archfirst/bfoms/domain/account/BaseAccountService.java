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

import java.util.List;

import javax.inject.Inject;

import org.archfirst.bfoms.domain.pricing.Instrument;
import org.archfirst.common.money.Money;
import org.archfirst.common.quantity.DecimalQuantity;
import org.joda.time.DateTime;

/**
 * BaseAccountService
 *
 * @author Naresh Bhatia
 */
public class BaseAccountService {
    
    @Inject
    private BaseAccountRepository baseAccountRepository;

    // ----- Commands -----
    public void transferCash(
            Money amount,
            Long fromAccountId,
            Long toAccountId) {

        this.transferCash(
                amount,
                this.findAccount(fromAccountId),
                this.findAccount(toAccountId));
    }
    
    public void transferCash(
            Money amount,
            BaseAccount fromAccount,
            BaseAccount toAccount) {
        
        DateTime now = new DateTime();
        CashTransfer fromTransfer = new CashTransfer(now, amount.negate(), toAccount);
        CashTransfer toTransfer = new CashTransfer(now, amount, fromAccount);
        baseAccountRepository.persist(fromTransfer);
        baseAccountRepository.persist(toTransfer);
        baseAccountRepository.flush(); // get object ids before adding to set
        fromAccount.transferCash(fromTransfer);
        toAccount.transferCash(toTransfer);
    }

    public void transferSecurities(
            Instrument instrument,
            DecimalQuantity quantity,
            Money pricePaidPerShare,
            BaseAccount fromAccount,
            BaseAccount toAccount) {
        
        DateTime now = new DateTime();
        SecuritiesTransfer fromTransfer = new SecuritiesTransfer(
                now, instrument, quantity.negate(), pricePaidPerShare, toAccount);
        SecuritiesTransfer toTransfer = new SecuritiesTransfer(
                now, instrument, quantity, pricePaidPerShare, fromAccount);
        baseAccountRepository.persist(fromTransfer);
        baseAccountRepository.persist(toTransfer);
        baseAccountRepository.flush(); // get object ids before adding to set
        fromAccount.transferSecurities(fromTransfer);
        toAccount.transferSecurities(toTransfer);
    }

    // ----- Queries and Read-Only Operations -----
    public BaseAccount findAccount(Long id) {
        return baseAccountRepository.findAccount(id);
    }
    
    public List<Transaction> findTransactions(TransactionCriteria criteria) {
        return baseAccountRepository.findTransactions(criteria);
    }
}