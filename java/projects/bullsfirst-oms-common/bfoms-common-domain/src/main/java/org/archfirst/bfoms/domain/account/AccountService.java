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

import javax.inject.Inject;

import org.archfirst.common.money.Money;
import org.joda.time.DateTime;

/**
 * AccountService
 *
 * @author Naresh Bhatia
 */
public class AccountService {
    
    @Inject
    private AccountRepository accountRepository;

    // ----- Commands -----
    public void transferCash(
            Money amount,
            BaseAccount fromAccount,
            BaseAccount toAccount) {
        
        // Transfer cash
        fromAccount.withdraw(amount);
        toAccount.deposit(amount);
        
        // Record a transaction in each account
        DateTime now = new DateTime();
        CashTransfer fromTransfer = new CashTransfer(now, toAccount, amount.negate());
        CashTransfer toTransfer = new CashTransfer(now, fromAccount, amount);
        accountRepository.persist(fromTransfer);
        accountRepository.persist(toTransfer);
        accountRepository.flush(); // get object ids before adding to set
        fromAccount.addTransaction(fromTransfer);
        toAccount.addTransaction(toTransfer);
    }

    // ----- Queries and Read-Only Operations -----
}