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
import org.archfirst.bfoms.domain.account.brokerage.order.OrderParams;
import org.archfirst.bfoms.domain.marketdata.MarketDataService;
import org.archfirst.bfoms.domain.referencedata.ReferenceDataService;
import org.archfirst.bfoms.domain.security.AuthorizationException;
import org.archfirst.bfoms.domain.security.User;
import org.archfirst.bfoms.domain.security.UserRepository;

/**
 * BrokerageAccountService
 *
 * @author Naresh Bhatia
 */
public class BrokerageAccountService {
    
    @Inject private BrokerageAccountFactory brokerageAccountFactory;
    @Inject private BrokerageAccountRepository brokerageAccountRepository;
    @Inject private MarketDataService marketDataService;
    @Inject private ReferenceDataService referenceDataService;
    @Inject private UserRepository userRepository;

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

        // Check authorization on account
        BrokerageAccount account =  checkAccountAuthorization(
                getUser(username), accountId, BrokerageAccountPermission.Trade);

        // Check if the symbol is valid
        if (this.referenceDataService.lookup(params.getSymbol()) == null) {
            throw new InvalidSymbolException();
        }
        
        return account.placeOrder(params);
    }
    
    public void processExecutionReport(Long accountId, ExecutionReport executionReport) {
        this.findAccount(accountId).processExecutionReport(executionReport);
    }
    
    // ----- Queries and Read-Only Operations -----
    public BrokerageAccount findAccount(Long id) {
        return brokerageAccountRepository.findAccount(id);
    }
    
    public List<Lot> findActiveLots(Long accountId) {
        return brokerageAccountRepository.findActiveLots(findAccount(accountId));
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
    
    // ----- Helpers -----
    private BrokerageAccount checkAccountAuthorization(
            User user,
            long accountId,
            BrokerageAccountPermission requiredPermission) {
        
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
    
    // ----- Helper Methods -----
    private User getUser(String username) {
        return userRepository.findUser(username);
    }
}