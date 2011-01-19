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

import org.archfirst.common.domain.BaseRepository;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;

/**
 * BaseAccountRepository
 *
 * @author Naresh Bhatia
 */
public class BaseAccountRepository extends BaseRepository {

    // ----- Transaction Methods -----
    public List<Transaction> findTransactions(TransactionCriteria criteria) {
        
        Session session = ((org.hibernate.ejb.EntityManagerImpl)em.getDelegate()).getSession(); 
        Criteria transactionCriteria = session.createCriteria(Transaction.class);

        if (criteria.getAccountId() != null) {
            transactionCriteria.add(Restrictions.eq("account.id", criteria.getAccountId()));
        }

        if (criteria.getFromDate() != null) {
            transactionCriteria.add(Restrictions.ge("creationTime", criteria.getFromDate().toDateTimeAtStartOfDay()));
        }

        if (criteria.getToDate() != null) {
            transactionCriteria.add(Restrictions.lt("creationTime", criteria.getToDate().plusDays(1).toDateTimeAtStartOfDay()));
        }

        @SuppressWarnings("unchecked")
        List<Transaction> transactions = (List<Transaction>)transactionCriteria.list();

        return transactions;
    }
}