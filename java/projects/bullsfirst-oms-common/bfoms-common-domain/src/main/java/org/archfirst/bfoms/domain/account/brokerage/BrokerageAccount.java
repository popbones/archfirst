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
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.OneToMany;
import javax.persistence.Transient;

import org.archfirst.bfoms.domain.account.AccountStatus;
import org.archfirst.bfoms.domain.account.BaseAccount;
import org.archfirst.bfoms.domain.account.CashTransfer;
import org.archfirst.bfoms.domain.account.OwnershipType;
import org.archfirst.bfoms.domain.account.SecuritiesTransfer;
import org.archfirst.bfoms.domain.account.brokerage.order.ExecutionReport;
import org.archfirst.bfoms.domain.account.brokerage.order.Order;
import org.archfirst.bfoms.domain.account.brokerage.order.OrderCompliance;
import org.archfirst.bfoms.domain.account.brokerage.order.OrderEstimate;
import org.archfirst.bfoms.domain.account.brokerage.order.OrderSide;
import org.archfirst.bfoms.domain.marketdata.MarketDataService;
import org.archfirst.bfoms.domain.referencedata.ReferenceDataService;
import org.archfirst.bfoms.domain.security.User;
import org.archfirst.bfoms.domain.util.Constants;
import org.archfirst.common.money.Money;
import org.archfirst.common.quantity.DecimalQuantity;
import org.hibernate.annotations.Parameter;
import org.hibernate.annotations.Type;
import org.joda.time.DateTime;

/**
 * BrokerageAccount
 *
 * @author Naresh Bhatia
 */
@Entity
public class BrokerageAccount extends BaseAccount {
    private static final long serialVersionUID = 1L;
    
    private OwnershipType ownershipType = OwnershipType.Individual;
    private Money cashPosition = new Money("0.00");
    private Set<Order> orders = new HashSet<Order>();
    private Set<Lot> lots = new HashSet<Lot>();
    
    @Transient
    private BrokerageAccountRepository brokerageAccountRepository;

    // ----- Constructors -----
    private BrokerageAccount() {
    }

    // Allow access only from AccountService
    BrokerageAccount(String name, AccountStatus status,
            OwnershipType ownershipType, Money cashPosition) {
        super(name, status);
        this.ownershipType = ownershipType;
        this.cashPosition = cashPosition;
    }

    // ----- Commands -----
    @Override
    public void transferCash(CashTransfer transfer) {
        cashPosition = cashPosition.plus(transfer.getAmount());
        this.addTransaction(transfer);
    }
    
    @Override
    public void transferSecurities(SecuritiesTransfer transfer) {
        if (transfer.getQuantity().isPlus()) {
            depositSecurities(
                    transfer.getSymbol(),
                    transfer.getQuantity(),
                    transfer.getPricePaidPerShare(),
                    new SecuritiesTransferAllocationFactory(brokerageAccountRepository, transfer));
        }
        else {
            withdrawSecurities(    
                transfer.getSymbol(),
                transfer.getQuantity().negate(),
                new SecuritiesTransferAllocationFactory(brokerageAccountRepository, transfer));
        }
        this.addTransaction(transfer);
    }

    private void depositSecurities(
            String symbol,
            DecimalQuantity quantity,
            Money pricePaidPerShare,
            AllocationFactory factory) {

        // Find lots for the specified instrument
        List<Lot> lots =
            brokerageAccountRepository.findActiveLots(this, symbol);

        // First deposit to lots that have negative quantity (unusual case)
        DecimalQuantity quantityLeftToDeposit = quantity;
        for (Lot lot : lots) {
            DecimalQuantity lotQuantity = lot.getQuantity();
            if (lotQuantity.isMinus()) {
                DecimalQuantity depositQuantity = lotQuantity.negate();
                lot.buy(depositQuantity, pricePaidPerShare);
                lot.addAllocation(factory.createAllocation(depositQuantity));
                quantityLeftToDeposit = quantityLeftToDeposit.minus(depositQuantity);
                if (quantityLeftToDeposit.isZero()) {
                    break;
                }
            }
        }

        // Put the remaining quantity in a new lot
        if (quantityLeftToDeposit.isPlus()) {
            Lot lot = new Lot(
                new DateTime(), symbol, quantityLeftToDeposit, pricePaidPerShare);
            brokerageAccountRepository.persistAndFlush(lot);
            this.addLot(lot);
            lot.addAllocation(factory.createAllocation(quantityLeftToDeposit));
        }
    }

    private void withdrawSecurities(
            String symbol,
            DecimalQuantity quantity,
            AllocationFactory factory) {

        // Find lots for the specified instrument
        List<Lot> lots =
            brokerageAccountRepository.findActiveLots(this, symbol);

        // Withdraw specified quantity from available lots
        DecimalQuantity quantityLeftToWithdraw = quantity;
        for (Lot lot : lots) {
            DecimalQuantity lotQuantity = lot.getQuantity();
            if (lotQuantity.isMinus()) {
                continue;
            }
            DecimalQuantity withdrawQuantity =
                (lotQuantity.gteq(quantityLeftToWithdraw)) ?
                        quantityLeftToWithdraw : lotQuantity;
            lot.sell(withdrawQuantity);
            lot.addAllocation(factory.createAllocation(withdrawQuantity.negate()));
            quantityLeftToWithdraw = quantityLeftToWithdraw.minus(withdrawQuantity);
            if (quantityLeftToWithdraw.isZero()) {
                break;
            }
        }

        // If some quantity remains (unusual case), just create a lot with
        // negative quantity. This case can happen if a long standing sell
        // order gets executed.
        if (quantityLeftToWithdraw.isPlus()) {
            Lot lot = new Lot(
                    new DateTime(),
                    symbol,
                    quantityLeftToWithdraw.negate(),
                    new Money("0.00"));
                brokerageAccountRepository.persistAndFlush(lot);
                this.addLot(lot);
                lot.addAllocation(factory.createAllocation(quantityLeftToWithdraw));
        }
    }
    
    public void placeOrder(Order order) {
        order.setCreationTime(new DateTime());
        brokerageAccountRepository.persistAndFlush(order);
        this.addOrder(order);
    }
    
    public void processExecutionReport(ExecutionReport executionReport) {
        Order order =
            brokerageAccountRepository.findOrder(executionReport.getClientOrderId());
        Trade trade = order.processExecutionReport(executionReport, brokerageAccountRepository);
        if (trade != null) {
            if (trade.getSide() == OrderSide.Buy) {
                cashPosition = cashPosition.minus(
                        trade.getAmount().negate()); // trade.amount is negative
                depositSecurities(
                        trade.getSymbol(),
                        trade.getQuantity(),
                        trade.getPricePerShare(),
                        new TradeAllocationFactory(brokerageAccountRepository, trade));
            }
            else {
                cashPosition = cashPosition.plus(
                        trade.getAmount()); // trade.amount is positive
                withdrawSecurities(    
                        trade.getSymbol(),
                        trade.getQuantity(),
                        new TradeAllocationFactory(brokerageAccountRepository, trade));
            }
            this.addTransaction(trade);
        }
    }

    // ----- Queries and Read-Only Operations -----
    public AccountSummary getAccountSummary(
            User user,
            ReferenceDataService referenceDataService,
            MarketDataService marketDataService) {
        
        List<Position> positions =
            this.getPositions(referenceDataService, marketDataService);
        Money marketValue = new Money();
        for (Position position : positions) {
            marketValue = marketValue.plus(position.getMarketValue());
        }
        
        List<BrokerageAccountPermission> permissions =
            brokerageAccountRepository.findPermissionsForAccount(user, this);
        
        return new AccountSummary(
                this.id,
                this.name,
                this.cashPosition,
                marketValue,
                permissions.contains(BrokerageAccountPermission.Edit),
                permissions.contains(BrokerageAccountPermission.Trade),
                permissions.contains(BrokerageAccountPermission.Transfer),
                positions);
    }

    public List<Position> getPositions(
            ReferenceDataService referenceDataService,
            MarketDataService marketDataService) {
        
        List<Lot> lots = brokerageAccountRepository.findActiveLots(this);
        
        // Add lot positions
        List<Position> positions = new ArrayList<Position>();
        for (Lot lot : lots) {
            Position position = new Position(this.id, this.name);
            position.setLotPosition(
                    lot.getSymbol(),
                    referenceDataService.lookup(lot.getSymbol()).getName(),
                    lot.getId(),
                    lot.getCreationTime(),
                    lot.getQuantity(),
                    marketDataService.getMarketPrice(lot.getSymbol()),
                    lot.getPricePaidPerShare());
            positions.add(position);
        }
        
        // Add cash position
        Position position = new Position(this.id, this.name);
        position.setCashPosition(this.cashPosition);
        positions.add(position);
        
        return positions;
    }
    
    @Override
    public boolean isCashAvailable(
            Money amount,
            MarketDataService marketDataService) {
        return amount.lteq(calculateCashAvailable(marketDataService));
    }
    
    public Money calculateCashAvailable(MarketDataService pricingService) {

        Money cashAvailable = cashPosition;
        
        // Reduce cash available by estimated cost of buy orders
        List<Order> orders = brokerageAccountRepository.findActiveBuyOrders(this);
        for (Order order : orders) {
            OrderEstimate orderEstimate =
                order.calculateOrderEstimate(pricingService);
            cashAvailable =
                cashAvailable.minus(orderEstimate.getEstimatedValueInclFees());
        }
        
        return cashAvailable;
    }
    

    @Override
    public boolean isSecurityAvailable(
            String symbol,
            DecimalQuantity quantity) {
        return quantity.lteq(calculateSecurityAvailable(symbol));
    }
    
    public DecimalQuantity calculateSecurityAvailable(String symbol) {

        DecimalQuantity securityAvailable =
            brokerageAccountRepository.getNumberOfShares(this, symbol);

        // Reduce security available by estimated quantity of sell orders
        List<Order> orders =
            brokerageAccountRepository.findActiveSellOrders(this, symbol);
        for (Order order : orders) {
            securityAvailable = securityAvailable.minus(order.getQuantity());
        }
        
        return securityAvailable;
    }

    public OrderEstimate calculateOrderEstimate(
            Order order,
            MarketDataService marketDataService) {

        OrderEstimate orderEstimate = order.calculateOrderEstimate(marketDataService);

        // Determine account level compliance
        if (orderEstimate.getCompliance() == null) {
            OrderCompliance compliance = (order.getSide() == OrderSide.Buy) ?
                    calculateBuyOrderCompliance(order, marketDataService) :
                    calculateSellOrderCompliance(order);
            orderEstimate.setCompliance(compliance);
        }

        return orderEstimate;
    }
    
    private OrderCompliance calculateBuyOrderCompliance(
            Order order,
            MarketDataService marketDataService) {

        // Check if sufficient cash is available
        OrderEstimate orderEstimate = order.calculateOrderEstimate(marketDataService);
        return isCashAvailable(
                orderEstimate.getEstimatedValueInclFees(),
                marketDataService) ?
                    OrderCompliance.Compliant :
                    OrderCompliance.InsufficientFunds;
    }

    private OrderCompliance calculateSellOrderCompliance(Order order) {

        // Check if sufficient securities are available
        return isSecurityAvailable(
                order.getSymbol(), order.getQuantity()) ?
                OrderCompliance.Compliant : OrderCompliance.InsufficientQuantity;
    }

    @Transient
    public String getDisplayString() {
        return toString();
    }

    @Override
    public String toString() {
        StringBuilder builder = new StringBuilder();
        builder.append(name).append(" - ");
        builder.append(id).append(" | ");
        builder.append(cashPosition);
        return builder.toString();
    }

    // ----- Getters and Setters -----
    @Type(
        type = "org.archfirst.common.hibernate.GenericEnumUserType",
        parameters = {
            @Parameter (
                name  = "enumClass",
                value = "org.archfirst.bfoms.domain.account.OwnershipType")
            }
    )
    @Column(length=Constants.ENUM_COLUMN_LENGTH)
    public OwnershipType getOwnershipType() {
        return ownershipType;
    }
    private void setOwnershipType(OwnershipType ownershipType) {
        this.ownershipType = ownershipType;
    }

    @Embedded
    @AttributeOverrides({
        @AttributeOverride(name="amount",
            column = @Column(
                    name="cashpos_amount",
                    precision=Constants.MONEY_PRECISION,
                    scale=Constants.MONEY_SCALE)),
        @AttributeOverride(name="currency",
            column = @Column(
                    name="cashpos_currency",
                    length=Money.CURRENCY_LENGTH))
     })
    public Money getCashPosition() {
        return cashPosition;
    }
    private void setCashPosition(Money cashPosition) {
        this.cashPosition = cashPosition;
    }

    @OneToMany(mappedBy="account",  cascade=CascadeType.ALL)
    public Set<Order> getOrders() {
        return orders;
    }
    private void setOrders(Set<Order> orders) {
        this.orders = orders;
    }

    private void addOrder(Order order) {
        orders.add(order);
        order.setAccount(this);
    }

    @OneToMany(mappedBy="account", cascade=CascadeType.ALL)
    public Set<Lot> getLots() {
        return lots;
    }
    private void setLots(Set<Lot> lots) {
        this.lots = lots;
    }
     
    private void addLot(Lot lot) {
        lots.add(lot);
        lot.setAccount(this);
    }

    public void setBrokerageAccountRepository(
            BrokerageAccountRepository brokerageAccountRepository) {
        this.brokerageAccountRepository = brokerageAccountRepository;
    }

    // ----- AllocationFactory -----

    private abstract class AllocationFactory {
        
        protected BrokerageAccountRepository accountRepository;
        
        public AllocationFactory(BrokerageAccountRepository accountRepository) {
            this.accountRepository = accountRepository;
        }
        
        public abstract Allocation createAllocation(DecimalQuantity quantity);
    }
    
    private class SecuritiesTransferAllocationFactory extends AllocationFactory {
        
        private SecuritiesTransfer transfer;
        
        public SecuritiesTransferAllocationFactory(
                BrokerageAccountRepository accountRepository,
                SecuritiesTransfer transfer) {
            super(accountRepository);
            this.transfer = transfer;
        }

        @Override
        public Allocation createAllocation(DecimalQuantity quantity) {
            SecuritiesTransferAllocation allocation =
                new SecuritiesTransferAllocation(quantity, transfer);
            accountRepository.persistAndFlush(allocation);
            return allocation;
        }
    }
    
    private class TradeAllocationFactory extends AllocationFactory {
        
        private Trade trade;
        
        public TradeAllocationFactory(
                BrokerageAccountRepository accountRepository,
                Trade trade) {
            super(accountRepository);
            this.trade = trade;
        }

        @Override
        public Allocation createAllocation(DecimalQuantity quantity) {
            TradeAllocation allocation =
                new TradeAllocation(quantity, trade);
            accountRepository.persistAndFlush(allocation);
            return allocation;
        }
    }
}