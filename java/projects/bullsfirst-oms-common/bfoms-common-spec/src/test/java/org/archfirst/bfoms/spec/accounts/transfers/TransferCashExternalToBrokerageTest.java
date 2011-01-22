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
package org.archfirst.bfoms.spec.accounts.transfers;

import java.math.BigDecimal;
import java.util.List;

import org.archfirst.bfoms.domain.account.CashTransfer;
import org.archfirst.bfoms.domain.account.Transaction;
import org.archfirst.bfoms.domain.account.TransactionCriteria;
import org.archfirst.bfoms.domain.account.brokerage.BrokerageAccount;
import org.archfirst.bfoms.spec.accounts.BaseAccountsTest;
import org.archfirst.common.money.Money;
import org.testng.Assert;

/**
 * TransferCashExternalToBrokerage
 *
 * @author Naresh Bhatia
 */
public class TransferCashExternalToBrokerageTest extends BaseAccountsTest {

    public void transfer(BigDecimal amount) throws Exception {

        // Create accounts
        this.createUser1();
        this.createBrokerageAccount1();
        this.createExternalAccount1();

        // Transfer cash
        this.baseAccountService.transferCash(
                new Money(amount), externalAccount1Id, brokerageAccount1Id);
    }
    
    public Money getBrokerageAccountCashPosition() {
        BrokerageAccount account =
            brokerageAccountService.findAccount(brokerageAccount1Id);
        return account.getCashPosition();
    }
    
    public Money getExternalAccountCashTransferAmount() throws Exception {
        return getCashTransferAmount(this.externalAccount1Id);
    }

    public Money getBrokerageAccountCashTransferAmount() throws Exception {
        return getCashTransferAmount(this.brokerageAccount1Id);
    }

    /**
     * Gets the CashTransfer amount for the specified account. Assumes
     * only one transaction on the account and that transaction being a
     * CashTransfer.
     */
    private Money getCashTransferAmount(Long accountId) throws Exception {
        TransactionCriteria criteria = new TransactionCriteria();
        criteria.setAccountId(accountId);

        List<Transaction> transactions =
            this.baseAccountService.findTransactions(criteria);
        Assert.assertEquals(transactions.size(), 1);

        Transaction transaction = transactions.get(0);
        Assert.assertTrue(CashTransfer.class.isInstance(transaction));
        
        return ((CashTransfer)transaction).getAmount();
    }
}