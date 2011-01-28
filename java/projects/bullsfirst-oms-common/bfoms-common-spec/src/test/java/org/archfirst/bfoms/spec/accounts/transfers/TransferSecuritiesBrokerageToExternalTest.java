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

import java.util.List;

import org.archfirst.bfoms.domain.account.brokerage.Lot;
import org.archfirst.bfoms.spec.accounts.BaseAccountsTest;
import org.archfirst.common.money.Money;
import org.archfirst.common.quantity.DecimalQuantity;
import org.testng.Assert;

/**
 * TransferSecuritiesBrokerageToExternalTest
 *
 * @author Naresh Bhatia
 */
public class TransferSecuritiesBrokerageToExternalTest extends BaseAccountsTest {
    
    public void setBrokerageAccountInstrumentPosition(String symbol, int quantity) throws Exception {

        // Create accounts
        this.createUser1();
        this.createBrokerageAccount1();
        this.createExternalAccount1();

        // Set instrument position
        this.baseAccountService.transferSecurities(
                USERNAME1, symbol, new DecimalQuantity(quantity), new Money(),
                this.externalAccount1Id, this.brokerageAccount1Id);
    }

    public void transfer(String symbol, int quantity) {
        this.baseAccountService.transferSecurities(
                USERNAME1, symbol, new DecimalQuantity(quantity), new Money(),
                this.brokerageAccount1Id, this.externalAccount1Id);
    }
    
    public DecimalQuantity getBrokerageAccountInstrumentPosition(String symbol) {
        List<Lot> lots =
            this.brokerageAccountService.findActiveLots(brokerageAccount1Id);
        Assert.assertEquals(lots.size(), 1);
        Lot lot = lots.get(0);
        Assert.assertEquals(lot.getSymbol(), symbol);
        return lot.getQuantity();
    }
}