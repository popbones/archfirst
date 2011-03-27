/**
 * Copyright 2010 Archfirst
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
import java.util.Set;
import java.util.TreeSet;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.JoinType;
import javax.persistence.criteria.Path;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import org.archfirst.bfoms.domain.account.brokerage.order.Order;
import org.archfirst.bfoms.domain.account.brokerage.order.Order_;
import org.archfirst.bfoms.domain.account.brokerage.order.OrderCriteria;
import org.archfirst.bfoms.domain.account.brokerage.order.OrderSide;
import org.archfirst.bfoms.domain.account.brokerage.order.OrderStatus;
import org.archfirst.bfoms.domain.security.User;
import org.archfirst.common.domain.BaseRepository;
import org.archfirst.common.quantity.DecimalQuantity;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * BrokerageAccountRepository
 *
 * @author Naresh Bhatia
 */
public class BrokerageAccountRepository extends BaseRepository {
    private static final Logger logger =
        LoggerFactory.getLogger(BrokerageAccountRepository.class);

    // ----- BrokerageAccount Methods -----
    public BrokerageAccount findAccount(Long id) {
        BrokerageAccount account = entityManager.find(BrokerageAccount.class, id);
        if (account != null) {
            this.injectDependencies(account);
        }
        return account;
    }

    public List<BrokerageAccount> findAccountsWithPermission(
            User user,
            BrokerageAccountPermission permission) {

        @SuppressWarnings("unchecked")
        List<BrokerageAccount> accounts = entityManager.createQuery(
                "select ace.target from BrokerageAccountAce ace " +
                "where ace.recipient = :recipient " +
                "and ace.permission = :permission")
            .setParameter("recipient", user)
            .setParameter("permission", permission)
            .getResultList();

        this.injectDependencies(accounts);
        
        return accounts;
    }
    
    public List<BrokerageAccountPermission> findPermissionsForAccount(
            User user,
            BrokerageAccount account) {

        @SuppressWarnings("unchecked")
        List<BrokerageAccountPermission> permissions = entityManager.createQuery(
                "select ace.permission from BrokerageAccountAce ace " +
                "where ace.recipient = :recipient " +
                "and ace.target = :target")
            .setParameter("recipient", user)
            .setParameter("target", account)
            .getResultList();

        return permissions;
    }

    public BrokerageAccount findAccountForOrder(Long orderId) {
        BrokerageAccount account = (BrokerageAccount)entityManager.createQuery(
                "select a from BrokerageAccount a " +
                "join a.orders o " +
                "where o.id = :id")
            .setParameter("id", orderId)
            .getSingleResult();
        if (account != null) {
            this.injectDependencies(account);
        }
        return account;
    }

    // ----- Order Methods -----
    public Order findOrder(Long orderId) {
        return entityManager.find(Order.class, orderId);
    }

    public List<Order> findOrders(OrderCriteria criteria) {

        CriteriaBuilder builder = entityManager.getCriteriaBuilder();
        CriteriaQuery<Order> query = builder.createQuery(Order.class);

        // select * from Order
        Root<Order> _order = query.from(Order.class);
        
        // Eager fetch executions (because executions are often needed along with orders) 
        _order.fetch(Order_.executions, JoinType.LEFT);
        
        // Construct a predicate for the where clause using conjunction
        Predicate predicate = builder.conjunction();
        
        // accountId
        if (criteria.getAccountId() != null) {
            logger.debug("---> findOrders: accountId={}", criteria.getAccountId());
            Path<BrokerageAccount> _account = _order.get(Order_.account);
            Path<Long> _accountId = _account.get(BrokerageAccount_.id);
            predicate = builder.and(
                    predicate,
                    builder.equal(_accountId, criteria.getAccountId()));
        }

        // symbol
        if (criteria.getSymbol() != null) {
            logger.debug("---> findOrders: symbol={}", criteria.getSymbol());
            predicate = builder.and(
                    predicate,
                    builder.equal(_order.get(Order_.symbol), criteria.getSymbol()));
        }

        // orderId
        if (criteria.getOrderId() != null) {
            logger.debug("---> findOrders: orderId={}", criteria.getOrderId());
            predicate = builder.and(
                    predicate,
                    builder.equal(_order.get(Order_.id), criteria.getOrderId()));
        }

        /*        
        // fromDate
        if (criteria.getFromDate() != null) {
            logger.debug("---> findOrders: fromDate()={}", criteria.getFromDate());
            query.where(builder.ge(
                    _order.get(Order_.creationTime),
                    criteria.getFromDate().toDateTimeAtStartOfDay()));
        }

        if (criteria.getToDate() != null) {
            logger.debug("---> findOrders: toDate()={}", criteria.getToDate());
            query.where(builder.lt(
                    _order.get(Order_.creationTime),
                    criteria.getToDate().toDateTimeAtStartOfDay()));
        }

        if (!criteria.getSides().isEmpty()) {
            orderCriteria.add(Restrictions.in("side",
                    criteria.getSides()));
        }

        if (!criteria.getStatuses().isEmpty()) {
            orderCriteria.add(Restrictions.in("status",
                    criteria.getStatuses()));
        }
*/
        
        // Assign predicate to where clause
        query.where(predicate);
        
        // Execute the query
        List<Order> orders = entityManager.createQuery(query).getResultList();
        
        // Orders with multiple executions will be added to the above list multiple times
        // Filter out duplicates
        Set<Order> distinctOrderSet = new TreeSet<Order>(orders);
        List<Order> distinctOrderList = new ArrayList<Order>(distinctOrderSet);
        
        for (Order order : distinctOrderList) {
            logger.debug("---> findOrders: Order={}", order);
        }

        return distinctOrderList;
    }

    public List<Order> findActiveBuyOrders(BrokerageAccount account) {
        OrderCriteria criteria = new OrderCriteria();

        criteria.setAccountId(account.getId());

        List<OrderSide> sides = new ArrayList<OrderSide>();
        sides.add(OrderSide.Buy);
        criteria.setSides(sides);
        
        List<OrderStatus> statuses = new ArrayList<OrderStatus>();
        statuses.add(OrderStatus.New);
        statuses.add(OrderStatus.PartiallyFilled);
        statuses.add(OrderStatus.PendingNew);
        statuses.add(OrderStatus.PendingCancel);
        criteria.setStatuses(statuses);

        return findOrders(criteria);
    }

    public List<Order> findActiveSellOrders(
            BrokerageAccount account, String symbol) {

        OrderCriteria criteria = new OrderCriteria();

        criteria.setAccountId(account.getId());
        criteria.setSymbol(symbol);

        List<OrderSide> sides = new ArrayList<OrderSide>();
        sides.add(OrderSide.Sell);
        criteria.setSides(sides);
        
        List<OrderStatus> statuses = new ArrayList<OrderStatus>();
        statuses.add(OrderStatus.New);
        statuses.add(OrderStatus.PartiallyFilled);
        statuses.add(OrderStatus.PendingNew);
        statuses.add(OrderStatus.PendingCancel);
        criteria.setStatuses(statuses);

        return findOrders(criteria);
    }

    public void refreshOrders(List<Order> orders) {
        for (Order order : orders) {
            entityManager.refresh(order);
        }
    }

    // ----- Lot Methods -----
    public List<Lot> findActiveLots(BrokerageAccount account, String symbol) {
        @SuppressWarnings("unchecked")
        List<Lot> lots = entityManager.createQuery(
                "select l from Lot l " +
                "join l.account a " +
                "where a = :account " +
                "and l.symbol = :symbol " +
                "and l.quantity <> 0 " +
                "order by l.creationTime")
            .setParameter("account", account)
            .setParameter("symbol", symbol)
            .getResultList();
        return lots;
    }

    public List<Lot> findActiveLots(BrokerageAccount account) {
        @SuppressWarnings("unchecked")
        List<Lot> lots = entityManager.createQuery(
                "select l from Lot l " +
                "join l.account a " +
                "where a = :account " +
                "and l.quantity <> 0 " +
                "order by l.symbol, l.creationTime")
            .setParameter("account", account)
            .getResultList();
        return lots;
    }

    public DecimalQuantity getNumberOfShares(
            BrokerageAccount account, String symbol) {
        
        DecimalQuantity numberOfShares = DecimalQuantity.ZERO;
        
        List<Lot> lots = findActiveLots(account, symbol);
        for (Lot lot : lots) {
            numberOfShares = numberOfShares.plus(lot.getQuantity());
        }

        return numberOfShares;
    }

    // ----- Helper Methods -----
    public void injectDependencies(List<BrokerageAccount> accounts) {
        for (BrokerageAccount account : accounts) {
            account.setBrokerageAccountRepository(this);
        }
    }
    
    public void injectDependencies(BrokerageAccount account) {
        account.setBrokerageAccountRepository(this);
    }
}