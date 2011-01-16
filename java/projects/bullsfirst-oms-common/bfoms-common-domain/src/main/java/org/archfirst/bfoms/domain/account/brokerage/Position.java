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

import java.util.List;

import org.archfirst.bfoms.domain.util.Constants;
import org.archfirst.common.datetime.DateTimeUtil;
import org.archfirst.common.money.Money;
import org.archfirst.common.quantity.DecimalQuantity;
import org.archfirst.common.quantity.Percentage;
import org.joda.time.DateTime;

/**
 * Position
 *
 * @author Naresh Bhatia
 */
public class Position {
    private Long accountId;
    private String accountName;
    private String instrumentSymbol;
    private String instrumentName;
    private Long lotId;
    private DateTime lotCreationTime;
    private DecimalQuantity quantity;
    private Money lastTrade;
    private Money marketValue;
    private Money pricePaid;
    private Money totalCost;
    private Money gain;
    private Percentage gainPercent;
    private List<Position> children;

    // ----- Constructors -----
    public Position() {
    }

    public Position(Long accountId, String accountName) {
        this.accountId = accountId;
        this.accountName = accountName;
    }

    // ----- Commands -----
    public void setCashPosition(Money marketValue) {
        this.instrumentSymbol = Constants.CASH_INSTRUMENT_SYMBOL;
        this.instrumentName = Constants.CASH_INSTRUMENT_NAME;
        this.marketValue = marketValue;
    }
    
    public void setLotPosition(
            String instrumentSymbol,
            String instrumentName,
            Long lotId,
            DateTime lotCreationTime,
            DecimalQuantity quantity,
            Money lastTrade,
            Money pricePaid) {
        this.instrumentSymbol = instrumentSymbol;
        this.instrumentName = instrumentName;
        this.lotId = lotId;
        this.lotCreationTime = lotCreationTime;
        this.quantity = quantity;
        this.lastTrade = lastTrade;
        this.pricePaid = pricePaid;
        
        // Calculate values
        this.marketValue = lastTrade.times(quantity).scaleToCurrency();
        this.totalCost = pricePaid.times(quantity).scaleToCurrency();
        this.gain = marketValue.minus(totalCost);
        this.gainPercent = gain.getPercentage(totalCost, Constants.GAIN_SCALE);
    }
    
    public void addChild(Position position) {
        this.children.add(position);
    }
    
    // ----- Queries and Read-Only Operations -----
    @Override
    public String toString() {
        StringBuilder builder = new StringBuilder();
        builder.append("accountId=").append(accountId);
        builder.append("accountName=").append(accountName);
        builder.append(", instrumentSymbol=").append(instrumentSymbol);
        builder.append(", instrumentName=").append(instrumentName);
        builder.append(", lotId=").append(lotId);
        if (lotCreationTime != null) {
            builder.append(", lotCreationTime=").append(DateTimeUtil.toStringTimestamp(lotCreationTime)).append(",");
        }
        builder.append(", quantity=").append(quantity);
        builder.append(", lastTrade=").append(lastTrade);
        builder.append(", marketValue=").append(marketValue);
        builder.append(", pricePaid=").append(pricePaid);
        builder.append(", totalCost=").append(totalCost);
        builder.append(", gain=").append(gain);
        builder.append(", gainPercent=").append(gainPercent);
        return builder.toString();
    }
    
    public String toStringDeep() {
        return toStringDeep(0);
    }

    private String toStringDeep(int indent) {
        // Print self
        StringBuilder builder = new StringBuilder();
        for (int i=0; i<indent; i++) {
            builder.append(" ");
        }
        builder.append(this);

        // Print children
        if (children != null) {
            for (Position child : children) {
                builder.append("\n").append(child.toStringDeep(indent+2));
            }
        }

        return builder.toString();
    }

    // ----- Getters -----
    public Long getAccountId() {
        return accountId;
    }
    public String getAccountName() {
        return accountName;
    }
    public String getInstrumentSymbol() {
        return instrumentSymbol;
    }
    public String getInstrumentName() {
        return instrumentName;
    }
    public Long getLotId() {
        return lotId;
    }
    public DateTime getLotCreationTime() {
        return lotCreationTime;
    }
    public DecimalQuantity getQuantity() {
        return quantity;
    }
    public Money getLastTrade() {
        return lastTrade;
    }
    public Money getMarketValue() {
        return marketValue;
    }
    public Money getPricePaid() {
        return pricePaid;
    }
    public Money getTotalCost() {
        return totalCost;
    }
    public Money getGain() {
        return gain;
    }
    public Percentage getGainPercent() {
        return gainPercent;
    }
    public List<Position> getChildren() {
        return children;
    }
}