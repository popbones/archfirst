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

import org.archfirst.bfoms.domain.account.brokerage.order.Order;
import org.archfirst.bfoms.domain.account.brokerage.order.OrderCriteria;
import org.archfirst.bfoms.domain.account.brokerage.order.OrderSide;
import org.archfirst.bfoms.domain.account.brokerage.order.OrderStatus;
import org.archfirst.bfoms.domain.pricing.Instrument;
import org.archfirst.bfoms.domain.security.User;
import org.archfirst.common.domain.BaseRepository;
import org.archfirst.common.quantity.DecimalQuantity;
import org.hibernate.Criteria;
import org.hibernate.FetchMode;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;

/**
 * AccountRepository
 *
 * @author Naresh Bhatia
 */
public class BrokerageAccountRepository extends BaseRepository {

    // ----- BrokerageAccount Methods -----
    public List<BrokerageAccount> findAccountsWithPermission(
            User user,
            BrokerageAccountPermission permission) {

        @SuppressWarnings("unchecked")
        List<BrokerageAccount> accounts = entityManager.createQuery(
                "select ace.target from AccountAce ace " +
                "where ace.recipient = :recipient " +
                "and ace.permission = :permission")
            .setParameter("recipient", user)
            .setParameter("permission", permission)
            .getResultList();

        return accounts;
    }
    
    public BrokerageAccount findAccount(Long id) {
        return entityManager.find(BrokerageAccount.class, id);
    }

    public List<BrokerageAccountPermission> findPermissionsForAccount(
            User user,
            BrokerageAccount account) {

        @SuppressWarnings("unchecked")
        List<BrokerageAccountPermission> permissions = entityManager.createQuery(
                "select ace.permission from AccountAce ace " +
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
        return account;
    }

    // ----- Order Methods -----
    public Order findOrder(Long orderId) {
        return entityManager.find(Order.class, orderId);
    }

    public List<Order> findOrders(OrderCriteria criteria) {

        Session session = (Session)entityManager.getDelegate();

        // Create order criteria and eager fetch executions (because executions
        // are often needed along with orders) 
        Criteria orderCriteria =
            session.createCriteria(Order.class)
            .setFetchMode("executions", FetchMode.JOIN);


        if (criteria.getAccountId() != null) {
            orderCriteria.createCriteria("account").add(
                    Restrictions.eq("id", criteria.getAccountId()));
        }

        if (criteria.getSymbol() != null) {
            orderCriteria.createCriteria("instrument").add(
                    Restrictions.eq("symbol", criteria.getSymbol()));
        }

        if (criteria.getOrderId() != null) {
            orderCriteria.add(Restrictions.eq("id",
                    criteria.getOrderId()));
        }

        if (criteria.getFromDate() != null) {
            orderCriteria.add(Restrictions.ge("creationTime",
                    criteria.getFromDate().toDateTimeAtStartOfDay()));
        }

        if (criteria.getToDate() != null) {
            orderCriteria.add(Restrictions.lt("creationTime",
                    criteria.getToDate().plusDays(1).toDateTimeAtStartOfDay()));
        }

        if (!criteria.getSides().isEmpty()) {
            orderCriteria.add(Restrictions.in("side",
                    criteria.getSides()));
        }

        if (!criteria.getStatuses().isEmpty()) {
            orderCriteria.add(Restrictions.in("status",
                    criteria.getStatuses()));
        }

        @SuppressWarnings("unchecked")
        List<Order> orders = (List<Order>)orderCriteria.list();
        
        // Orders with multiple executions will be added to the above list multiple times
        // Filter out duplicates
        Set<Order> distinctOrderSet = new TreeSet<Order>(orders);
        List<Order> distinctOrderList = new ArrayList<Order>(distinctOrderSet);

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
            BrokerageAccount account, Instrument instrument) {

        OrderCriteria criteria = new OrderCriteria();

        criteria.setAccountId(account.getId());
        criteria.setSymbol(instrument.getSymbol());

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
    public List<Lot> findActiveLots(BrokerageAccount account, Instrument instrument) {
        @SuppressWarnings("unchecked")
        List<Lot> lots = entityManager.createQuery(
                "select l from Lot l " +
                "join l.account a " +
                "join l.instrument i " +
                "where a = :account " +
                "and i = :instrument " +
                "and l.quantity <> 0 " +
                "order by l.creationTime")
            .setParameter("account", account)
            .setParameter("instrument", instrument)
            .getResultList();
        return lots;
    }

    public List<Lot> findActiveLots(BrokerageAccount account) {
        @SuppressWarnings("unchecked")
        List<Lot> lots = entityManager.createQuery(
                "select l from Lot l " +
                "join l.account a " +
                "join l.instrument i " +
                "where a = :account " +
                "and l.quantity <> 0 " +
                "order by l.instrument, l.creationTime")
            .setParameter("account", account)
            .getResultList();
        return lots;
    }

    public DecimalQuantity getNumberOfShares(
            BrokerageAccount account, Instrument instrument) {
        
        DecimalQuantity numberOfShares = DecimalQuantity.ZERO;
        
        List<Lot> lots = findActiveLots(account, instrument);
        for (Lot lot : lots) {
            numberOfShares = numberOfShares.plus(lot.getQuantity());
        }

        return numberOfShares;
    }
}