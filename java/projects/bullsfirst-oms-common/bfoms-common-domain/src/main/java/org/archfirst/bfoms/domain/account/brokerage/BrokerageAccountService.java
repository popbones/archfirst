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

import java.util.List;

import javax.inject.Inject;

import org.archfirst.bfoms.domain.security.User;
import org.archfirst.bfoms.domain.security.UserRepository;
import org.archfirst.common.money.Money;

/**
 * BrokerageAccountService
 *
 * @author Naresh Bhatia
 */
public class BrokerageAccountService {
    
    @Inject private BrokerageAccountFactory brokerageAccountFactory;
    @Inject private BrokerageAccountRepository brokerageAccountRepository;
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

    // ----- Queries and Read-Only Operations -----
    public BrokerageAccount findAccount(Long id) {
        return brokerageAccountRepository.findAccount(id);
    }
    
    public List<Lot> findActiveLots(Long accountId) {
        return brokerageAccountRepository.findActiveLots(findAccount(accountId));
    }

    public AccountSummary getAccountSummary(String username, Long accountId) {
        
        BrokerageAccount account = this.findAccount(accountId);

        List<BrokerageAccountPermission> permissions =
            this.findPermissionsForAccount(username, account);
        
        return new AccountSummary(
                account.getId(),
                account.getName(),
                account.getCashPosition(),
                accountPosition.getMarketValue(), Money.class),
                permissions.contains(BrokerageAccountPermission.Edit),
                permissions.contains(BrokerageAccountPermission.Trade),
                permissions.contains(BrokerageAccountPermission.Transfer),
                account.getPositions(referenceDataService, marketDataService));
    }
    
    
    private User getUser(String username) {
        return userRepository.findUser(username);
    }
}