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

import org.archfirst.bfoms.domain.account.SecuritiesTransfer;
import org.archfirst.bfoms.domain.account.Transaction;
import org.archfirst.bfoms.domain.account.TransactionCriteria;
import org.archfirst.bfoms.domain.account.brokerage.Lot;
import org.archfirst.bfoms.spec.accounts.BaseAccountsTest;
import org.archfirst.common.money.Money;
import org.archfirst.common.quantity.DecimalQuantity;
import org.testng.Assert;

/**
 * TransferSecuritiesExternalToBrokerageTest
 *
 * @author Naresh Bhatia
 */
public class TransferSecuritiesExternalToBrokerageTest extends BaseAccountsTest {
    
    private Lot brokerageAccountLot;
    private SecuritiesTransfer brokerageAccountSecuritiesTransfer;
    private SecuritiesTransfer externalAccountSecuritiesTransfer;

    public void transfer(String symbol, BigDecimal quantity) throws Exception {

        this.initializeReferenceData();

        // Create accounts
        this.createUser1();
        this.createBrokerageAccount1();
        this.createExternalAccount1();

        // Transfer securities
        this.baseAccountService.transferSecurities(
                USERNAME1, symbol, new DecimalQuantity(quantity), new Money(),
                externalAccount1Id, brokerageAccount1Id);
        
        // Get lot for brokerage account
        List<Lot> lots =
            this.brokerageAccountService.findActiveLots(brokerageAccount1Id);
        Assert.assertEquals(lots.size(), 1);
        brokerageAccountLot = lots.get(0); 

        // Get SecuritiesTransfers for the two accounts
        brokerageAccountSecuritiesTransfer = getSecuritiesTransfer(brokerageAccount1Id);
        externalAccountSecuritiesTransfer = getSecuritiesTransfer(externalAccount1Id);
    }
    
    public String getBrokerageAccountLotSymbol() {
        return brokerageAccountLot.getSymbol();
    }
    
    public DecimalQuantity getBrokerageAccountLotQuantity() {
        return brokerageAccountLot.getQuantity();
    }
    
    public String getExternalAccountTransferSymbol() {
        return externalAccountSecuritiesTransfer.getSymbol();
    }

    public DecimalQuantity getExternalAccountTransferQuantity() {
        return externalAccountSecuritiesTransfer.getQuantity();
    }
    
    public String getBrokerageAccountTransferSymbol() {
        return brokerageAccountSecuritiesTransfer.getSymbol();
    }

    public DecimalQuantity getBrokerageAccountTransferQuantity() {
        return brokerageAccountSecuritiesTransfer.getQuantity();
    }

    /**
     * Gets the SecuritiesTransfer for the specified account. Assumes
     * only one transaction on the account and that transaction being a
     * SecuritiesTransfer.
     */
    private SecuritiesTransfer getSecuritiesTransfer(Long accountId) throws Exception {
        TransactionCriteria criteria = new TransactionCriteria();
        criteria.setAccountId(accountId);

        List<Transaction> transactions =
            this.baseAccountService.findTransactions(criteria);
        Assert.assertEquals(transactions.size(), 1);

        Transaction transaction = transactions.get(0);
        Assert.assertTrue(SecuritiesTransfer.class.isInstance(transaction));
        
        return ((SecuritiesTransfer)transaction);
    }
}