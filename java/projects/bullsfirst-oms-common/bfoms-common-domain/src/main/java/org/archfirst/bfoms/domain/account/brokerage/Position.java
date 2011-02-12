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

import java.util.Comparator;
import java.util.List;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

import org.archfirst.bfoms.domain.util.Constants;
import org.archfirst.common.datetime.DateTimeAdapter;
import org.archfirst.common.datetime.DateTimeUtil;
import org.archfirst.common.money.Money;
import org.archfirst.common.quantity.DecimalQuantity;
import org.joda.time.DateTime;

/**
 * Position
 *
 * @author Naresh Bhatia
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "Position")
public class Position {

    @XmlElement(name = "AccountId", required = true)
    private Long accountId;

    @XmlElement(name = "AccountName", required = true)
    private String accountName;

    @XmlElement(name = "InstrumentSymbol", required = true)
    private String instrumentSymbol;

    @XmlElement(name = "InstrumentName", required = true)
    private String instrumentName;

    @XmlElement(name = "LotId", required = true)
    private Long lotId;

    @XmlElement(name = "LotCreationTime", required = true)
    @XmlJavaTypeAdapter(DateTimeAdapter.class)
    private DateTime lotCreationTime;

// TODO: Uncomment when JAXB starts working in GlassFish
//    @XmlElement(name = "Quantity", required = true)
//    private DecimalQuantity quantity;

    @XmlElement(name = "LastTrade", required = true)
    private Money lastTrade;

    @XmlElement(name = "MarketValue", required = true)
    private Money marketValue;

    @XmlElement(name = "PricePaid", required = true)
    private Money pricePaid;

    @XmlElement(name = "TotalCost", required = true)
    private Money totalCost;

    @XmlElement(name = "Gain", required = true)
    private Money gain;

// TODO: Uncomment when JAXB starts working in GlassFish
//    @XmlElement(name = "GainPercent", required = true)
//    private Percentage gainPercent;

    @XmlElement(name = "Child", required = true)
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
//        this.quantity = quantity;
        this.lastTrade = lastTrade;
        this.pricePaid = pricePaid;
        
        // Calculate values
        this.marketValue = lastTrade.times(quantity).scaleToCurrency();
        this.totalCost = pricePaid.times(quantity).scaleToCurrency();
        this.gain = marketValue.minus(totalCost);
//        this.gainPercent = gain.getPercentage(totalCost, Constants.GAIN_SCALE);
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
//        builder.append(", quantity=").append(quantity);
        builder.append(", lastTrade=").append(lastTrade);
        builder.append(", marketValue=").append(marketValue);
        builder.append(", pricePaid=").append(pricePaid);
        builder.append(", totalCost=").append(totalCost);
        builder.append(", gain=").append(gain);
//        builder.append(", gainPercent=").append(gainPercent);
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
//    public DecimalQuantity getQuantity() {
//        return quantity;
//    }
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
//    public Percentage getGainPercent() {
//        return gainPercent;
//    }
    public List<Position> getChildren() {
        return children;
    }
    
    // ----- Comparators -----
    public static class LotCreationTimeComparator implements Comparator<Position> {

        @Override
        public int compare(Position position1, Position position2) {

            if (position1 == null) {
                return -1;
            }
            else if (position2 == null) {
                return 1;
            }
            else if (position1.getLotCreationTime() == null) {
                return -1;
            }
            else if (position2.getLotCreationTime() == null) {
                return 1;
            }
            
            return position1.getLotCreationTime().compareTo(position2.getLotCreationTime());
        }
    }
}