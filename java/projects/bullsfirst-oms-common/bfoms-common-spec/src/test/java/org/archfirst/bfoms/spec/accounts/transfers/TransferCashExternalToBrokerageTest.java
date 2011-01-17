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
import org.archfirst.bfoms.domain.account.external.ExternalAccount;
import org.archfirst.bfoms.spec.accounts.BaseAccountsTest;
import org.archfirst.common.money.Money;

/**
 * TransferCashExternalToBrokerage
 *
 * @author Naresh Bhatia
 */
public class TransferCashExternalToBrokerageTest extends BaseAccountsTest {

    public Money transfer(BigDecimal amount) throws Exception {

        // Create accounts
        this.createUser1();
        this.createBrokerageAccount1();
        this.createExternalAccount1();

        // Transfer cash
        ExternalAccount fromAccount =
            externalAccountService.findAccount(externalAccount1Id);
        BrokerageAccount toAccount =
            brokerageAccountService.findAccount(brokerageAccount1Id);
        this.baseAccountService.transferCash(
                new Money(amount), fromAccount, toAccount);
        return toAccount.getCashPosition();
    }
}