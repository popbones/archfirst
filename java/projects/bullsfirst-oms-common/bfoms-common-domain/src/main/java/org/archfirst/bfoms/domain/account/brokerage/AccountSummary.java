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

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

import org.archfirst.common.money.Money;

/**
 * AccountSummary
 *
 * @author Naresh Bhatia
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "AccountSummary", propOrder = {
    "id",
    "name",
    "cashPosition",
    "marketValue",
    "editPermission",
    "tradePermission",
    "transferPermission",
    "accountPosition"
})
public class AccountSummary {

    @XmlElement(name = "Id")
    protected long id;
    @XmlElement(name = "Name", required = true)
    protected String name;
    @XmlElement(name = "CashPosition", required = true)
    protected Money cashPosition;
    @XmlElement(name = "MarketValue", required = true)
    protected Money marketValue;
    @XmlElement(name = "EditPermission")
    protected boolean editPermission;
    @XmlElement(name = "TradePermission")
    protected boolean tradePermission;
    @XmlElement(name = "TransferPermission")
    protected boolean transferPermission;
    @XmlElement(name = "Positions", required = true)
    protected List<Position> positions;

    // ----- Constructors -----
    public AccountSummary() {
    }

    public AccountSummary(
            long id,
            String name,
            Money cashPosition,
            Money marketValue,
            boolean editPermission,
            boolean tradePermission,
            boolean transferPermission,
            List<Position> positions) {
        this.id = id;
        this.name = name;
        this.cashPosition = cashPosition;
        this.marketValue = marketValue;
        this.editPermission = editPermission;
        this.tradePermission = tradePermission;
        this.transferPermission = transferPermission;
        this.positions = positions;
    }

    // ----- Getters and Setters -----
    public long getId() {
        return id;
    }
    public void setId(long value) {
        this.id = value;
    }

    public String getName() {
        return name;
    }
    public void setName(String value) {
        this.name = value;
    }

    public Money getCashPosition() {
        return cashPosition;
    }
    public void setCashPosition(Money value) {
        this.cashPosition = value;
    }

    public Money getMarketValue() {
        return marketValue;
    }
    public void setMarketValue(Money value) {
        this.marketValue = value;
    }

    public boolean isEditPermission() {
        return editPermission;
    }
    public void setEditPermission(boolean value) {
        this.editPermission = value;
    }

    public boolean isTradePermission() {
        return tradePermission;
    }
    public void setTradePermission(boolean value) {
        this.tradePermission = value;
    }

    public boolean isTransferPermission() {
        return transferPermission;
    }
    public void setTransferPermission(boolean value) {
        this.transferPermission = value;
    }

    public List<Position> getPositions() {
        return positions;
    }
    public void setPositions(List<Position> positions) {
        this.positions = positions;
    }
}