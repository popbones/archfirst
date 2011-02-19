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
package org.archfirst.bfoms.domain.account;

import java.util.List;

import javax.inject.Inject;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Path;
import javax.persistence.criteria.Root;

import org.archfirst.bfoms.domain.account.brokerage.BrokerageAccount;
import org.archfirst.bfoms.domain.account.brokerage.BrokerageAccountRepository;
import org.archfirst.common.domain.BaseRepository;

/**
 * BaseAccountRepository
 *
 * @author Naresh Bhatia
 */
public class BaseAccountRepository extends BaseRepository {

    @Inject private BrokerageAccountRepository brokerageAccountRepository;
    
    // ----- BaseAccount Methods -----
    public BaseAccount findAccount(Long id) {
        BaseAccount account = entityManager.find(BaseAccount.class, id);
        if (BrokerageAccount.class.isInstance(account)) {
            brokerageAccountRepository.injectDependencies((BrokerageAccount)account);
        }
        return account;
    }

    // ----- Transaction Methods -----
    public List<Transaction> findTransactions(TransactionCriteria criteria) {
        
        CriteriaBuilder builder = entityManager.getCriteriaBuilder();
        CriteriaQuery<Transaction> query = builder.createQuery(Transaction.class);

        // select * from Transaction
        Root<Transaction> _transaction = query.from(Transaction.class);
        
        // where accountId = criteria.getAccountId()
        if (criteria.getAccountId() != null) {
            Path<BaseAccount> _account = _transaction.get(Transaction_.account);
            Path<Long> _accountId = _account.get(BaseAccount_.id);
            query.where(builder.equal(_accountId, criteria.getAccountId()));
        }

        if (criteria.getFromDate() != null) {
        }

        if (criteria.getToDate() != null) {
        }
       
        // Execute the query
        return entityManager.createQuery(query).getResultList();
    }
}