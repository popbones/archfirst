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
package org.archfirst.bfoms.domain.account.position;

import org.archfirst.bfoms.domain.util.Constants;
import org.archfirst.common.money.Money;
import org.archfirst.common.quantity.DecimalQuantity;
import org.joda.time.DateTime;

/**
 * Leaf level position - has no children
 *
 * @author Naresh Bhatia
 */
public class LotPosition extends Position {

    // ----- Constructors -----
    public LotPosition(
            Long id,
            DateTime creationTime,
            String name,
            String symbol,
            DecimalQuantity quantity,
            Money lastTrade,
            Money pricePaid) {
        this.id = id;
        this.creationTime = creationTime;
        this.name = name;
        this.symbol = symbol;
        this.quantity = quantity;
        this.lastTrade = lastTrade;
        this.pricePaid = pricePaid;
    }


    // ----- Commands -----
    @Override
    public void calculate() {
        marketValue = lastTrade.times(quantity).scaleToCurrency();
        totalCost = pricePaid.times(quantity).scaleToCurrency();
        gain = marketValue.minus(totalCost);
        gainPercent = gain.getPercentage(totalCost, Constants.GAIN_SCALE);
    }

    // ----- Getters -----
    public String getType() {
        return "LotPosition";
    }
}