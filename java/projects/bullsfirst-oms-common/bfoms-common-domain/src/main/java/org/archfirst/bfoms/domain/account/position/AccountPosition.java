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

import java.util.ArrayList;

import org.archfirst.bfoms.domain.util.Constants;
import org.archfirst.common.money.Money;

/**
 * AccountPosition
 *
 * @author Naresh Bhatia
 */
public class AccountPosition extends Position {

    // ----- Constructors -----
    public AccountPosition(Long id, String name) {
        this.id = id;
        this.name = name;
        children = new ArrayList<Position>();
    }

    // ----- Commands -----
    @Override
    public void calculate() {
        marketValue = new Money("0.00");
        totalCost = new Money("0.00");
        gain = new Money("0.00");
        
        for (Position child : children) {
            child.calculate();
            marketValue = marketValue.plus(child.getMarketValue());
            if (child.getTotalCost() != null) {  // since Cash has no totalCost
                totalCost = totalCost.plus(child.getTotalCost());
                gain = gain.plus(child.getGain());
            }
        }
        
        gainPercent = gain.getPercentage(totalCost, Constants.GAIN_SCALE);
    }

    // ----- Getters -----
    public String getType() {
        return "AccountPosition";
    }
}