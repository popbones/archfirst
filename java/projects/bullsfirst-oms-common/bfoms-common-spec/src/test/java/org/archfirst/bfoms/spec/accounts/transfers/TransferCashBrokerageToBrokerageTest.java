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

import org.archfirst.bfoms.domain.account.brokerage.BrokerageAccount;
import org.archfirst.bfoms.spec.accounts.BaseAccountsTest;
import org.archfirst.common.money.Money;

/**
 * TransferCashBrokerageToBrokerageTest
 *
 * @author Naresh Bhatia
 */
public class TransferCashBrokerageToBrokerageTest extends BaseAccountsTest {
    
    public void setBrokerageAccount1CashPosition(BigDecimal amount) throws Exception {

        // Create account
        this.createUser1();
        this.createBrokerageAccount1();
        this.createExternalAccount1();

        // Set cash position
        this.baseAccountService.transferCash(
                new Money(amount), this.externalAccount1Id, this.brokerageAccount1Id);
    }

    public void setBrokerageAccount2CashPosition(BigDecimal amount) {

        // Create account
        this.createBrokerageAccount2();

        // Set cash position
        this.baseAccountService.transferCash(
                new Money(amount), this.externalAccount1Id, this.brokerageAccount2Id);
    }

    public void transfer(BigDecimal amount) {
        this.baseAccountService.transferCash(
                new Money(amount), brokerageAccount1Id, brokerageAccount2Id);
    }
    
    public Money getBrokerageAccount1CashPosition() {
        BrokerageAccount account =
            brokerageAccountService.findAccount(brokerageAccount1Id);
        return account.getCashPosition();
    }
    
    public Money getBrokerageAccount2CashPosition() {
        BrokerageAccount account =
            brokerageAccountService.findAccount(brokerageAccount2Id);
        return account.getCashPosition();
    }
}