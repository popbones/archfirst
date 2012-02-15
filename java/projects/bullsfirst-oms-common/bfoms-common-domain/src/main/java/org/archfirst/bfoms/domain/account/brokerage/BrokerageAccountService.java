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
package org.archfirst.bfoms.domain.account.brokerage;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

import org.archfirst.bfoms.domain.account.InvalidSymbolException;
import org.archfirst.bfoms.domain.account.brokerage.order.ExecutionReport;
import org.archfirst.bfoms.domain.account.brokerage.order.Order;
import org.archfirst.bfoms.domain.account.brokerage.order.OrderCriteria;
import org.archfirst.bfoms.domain.account.brokerage.order.OrderEstimate;
import org.archfirst.bfoms.domain.account.brokerage.order.OrderEventPublisher;
import org.archfirst.bfoms.domain.account.brokerage.order.OrderParams;
import org.archfirst.bfoms.domain.account.brokerage.order.OrderStatus;
import org.archfirst.bfoms.domain.exchange.ExchangeTradingService;
import org.archfirst.bfoms.domain.marketdata.MarketDataService;
import org.archfirst.bfoms.domain.referencedata.ReferenceDataService;
import org.archfirst.bfoms.domain.security.AuthorizationException;
import org.archfirst.bfoms.domain.security.User;
import org.archfirst.bfoms.domain.security.UserRepository;
import org.archfirst.common.quantity.DecimalQuantity;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * BrokerageAccountService
 *
 * @author Naresh Bhatia
 */
public class BrokerageAccountService {
    private static final Logger logger =
        LoggerFactory.getLogger(BrokerageAccountService.class);

    // ----- Commands -----
    public Long openNewAccount(String username, String accountName) {

        User user = getUser(username);
        BrokerageAccount account =
            brokerageAccountFactory.createIndividualAccountWithFullAccess(
                accountName,
                user.getPerson(),
                user);
        return account.getId();
    }

    public Long placeOrder(String username, Long accountId, OrderParams params) {
        
        logger.debug("Place order in account {}: {}", accountId, params);

        // Check authorization on account
        BrokerageAccount account =  checkAccountAuthorization(
                getUser(username), accountId, BrokerageAccountPermission.Trade);

        // Check if the symbol is valid
        if (this.referenceDataService.lookup(params.getSymbol()) == null) {
            throw new InvalidSymbolException();
        }
        
        // Place order
        Order order = account.placeOrder(params, marketDataService);
        exchangeTradingService.placeOrder(order);
        return order.getId();
    }
    
    public void cancelOrder(String username, Long orderId) {

        // Find the order
        Order order = brokerageAccountRepository.findOrder(orderId);
        if (order == null) {
            throw new RuntimeException("Order " + orderId + " not found");
        }
        
        // Check authorization on account
        checkAccountAuthorization(
                getUser(username),
                order.getAccount().getId(),
                BrokerageAccountPermission.Trade);
        
        // Cancel order
        order.pendingCancel(orderEventPublisher);
        exchangeTradingService.cancelOrder(order);
    }

    public void processExecutionReport(ExecutionReport executionReport) {
        // Send to account for processing
        BrokerageAccount account = brokerageAccountRepository.findAccountForOrder(
                executionReport.getClientOrderId());
        account.processExecutionReport(executionReport);
    }
    
    public void processOrderCancelReject(Long orderId, OrderStatus newStatus) {
        
        // Get the order
        Order order = this.findOrder(orderId);
        if (order == null) {
            logger.error("OrderCancelReject: order {} not found", orderId);
        }

        // Send the new status to the order
        order.cancelRequestRejected(newStatus, orderEventPublisher);
    }

    // ----- Queries -----
    public BrokerageAccount findAccount(Long id) {
        return brokerageAccountRepository.findAccount(id);
    }
    
    public List<Lot> findActiveLots(Long accountId) {
        return brokerageAccountRepository.findActiveLots(findAccount(accountId));
    }

    public DecimalQuantity getNumberOfShares(Long accountId, String symbol) {
        return brokerageAccountRepository.getNumberOfShares(
                findAccount(accountId), symbol);
    }

    public Order findOrder(Long id) {
        return brokerageAccountRepository.findOrder(id);
    }
    
    public List<BrokerageAccountSummary> getAccountSummaries(String username) {
        
        User user = getUser(username);
        
        // Get a list of viewable accounts
        List<BrokerageAccount> viewableAccounts =
            brokerageAccountRepository.findAccountsWithPermission(
                    user, BrokerageAccountPermission.View);

        // Calculate account summaries
        List<BrokerageAccountSummary> accountSummaries = new ArrayList<BrokerageAccountSummary>();
        for (BrokerageAccount account : viewableAccounts) {
            accountSummaries.add(account.getAccountSummary(
                    user, referenceDataService, marketDataService));
        }

        return accountSummaries;
    }
    
    public BrokerageAccountSummary getAccountSummary(String username, Long accountId) {
        BrokerageAccount account = this.findAccount(accountId);
        return account.getAccountSummary(
                getUser(username), referenceDataService, marketDataService);
    }
    
    public List<Order> getOrders(String username, OrderCriteria criteria) {

        logger.debug("Get orders: {}", criteria);

        // Check authorization on account
        checkAccountAuthorization(
                getUser(username), criteria.getAccountId(), BrokerageAccountPermission.View);

        return brokerageAccountRepository.findOrders(criteria);
    }

    public OrderEstimate getOrderEstimate(
            String username,
            Long brokerageAccountId,
            OrderParams params) {

        // Check authorization on account
        BrokerageAccount account =  checkAccountAuthorization(
                getUser(username), brokerageAccountId, BrokerageAccountPermission.Trade);

        return account.calculateOrderEstimate(params, marketDataService);
    }

    // ----- Helpers -----
    private BrokerageAccount checkAccountAuthorization(
            User user,
            Long accountId,
            BrokerageAccountPermission requiredPermission) {
        
        if (accountId == null)
            throw new AuthorizationException();
        BrokerageAccount account = brokerageAccountRepository.findAccount(accountId);
        checkAccountAuthorizationHelper(user, account, requiredPermission);
        return account;
    }
    
    private void checkAccountAuthorizationHelper(
            User user,
            BrokerageAccount account,
            BrokerageAccountPermission requiredPermission) {

        List<BrokerageAccountPermission> permissions =
            brokerageAccountRepository.findPermissionsForAccount(user, account);
        if (!permissions.contains(requiredPermission)) {
            throw new AuthorizationException();
        }
    }
    
    private User getUser(String username) {
        return userRepository.findUser(username);
    }
    
    // ----- Attributes -----
    @Inject private BrokerageAccountFactory brokerageAccountFactory;
    @Inject private BrokerageAccountRepository brokerageAccountRepository;
    @Inject private MarketDataService marketDataService;
    @Inject private ReferenceDataService referenceDataService;
    @Inject private ExchangeTradingService exchangeTradingService;
    @Inject private UserRepository userRepository;
    @Inject private OrderEventPublisher orderEventPublisher;
}