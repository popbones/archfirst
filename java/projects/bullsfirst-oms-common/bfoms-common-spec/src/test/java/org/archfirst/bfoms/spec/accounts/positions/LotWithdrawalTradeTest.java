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
package org.archfirst.bfoms.spec.accounts.positions;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;

import org.archfirst.bfoms.domain.account.brokerage.Lot;
import org.archfirst.bfoms.domain.account.brokerage.order.ExecutionReport;
import org.archfirst.bfoms.domain.account.brokerage.order.Order;
import org.archfirst.bfoms.domain.account.brokerage.order.OrderSide;
import org.archfirst.bfoms.domain.account.brokerage.order.OrderStatus;
import org.archfirst.bfoms.domain.account.brokerage.order.OrderTerm;
import org.archfirst.bfoms.domain.account.brokerage.order.OrderType;
import org.archfirst.bfoms.spec.accounts.BaseAccountsTest;
import org.archfirst.common.money.Money;
import org.archfirst.common.quantity.DecimalQuantity;

/**
 * LotWithdrawalTradeTest
 *
 * @author Naresh Bhatia
 */
public class LotWithdrawalTradeTest extends BaseAccountsTest {
    
    public void setup() throws Exception {
        this.createUser1();
        this.createBrokerageAccount1();
        this.createExternalAccount1();
    }
    
    public void transferIn(String symbol, BigDecimal quantity, BigDecimal price) {
        this.baseAccountService.transferSecurities(
                symbol, new DecimalQuantity(quantity), new Money(price),
                externalAccount1Id, brokerageAccount1Id);
    }

    public List<Lot> sell(String symbol, BigDecimal quantity) {
        
        // Place the order
        Order order = new Order(
                OrderSide.Sell,
                symbol,
                new DecimalQuantity(quantity),
                OrderType.Market,
                null,
                OrderTerm.GoodTilCanceled,
                false);
        this.brokerageAccountService.placeOrder(brokerageAccount1Id, order);
        
        // Acknowledge the order
        ExecutionReport executionReport = ExecutionReport.createNewType(order);
        this.brokerageAccountService.processExecutionReport(
                brokerageAccount1Id, executionReport);
        
        // Execute the trade
        executionReport = ExecutionReport.createTradeType(
                order,
                OrderStatus.Filled,
                new DecimalQuantity(quantity),
                new Money());
        this.brokerageAccountService.processExecutionReport(
                brokerageAccount1Id, executionReport);
        
        List<Lot> lots =
            this.brokerageAccountService.findActiveLots(brokerageAccount1Id);
        Collections.sort(lots, new Lot.CreationTimeComparator());
        
        return lots;
    }
}