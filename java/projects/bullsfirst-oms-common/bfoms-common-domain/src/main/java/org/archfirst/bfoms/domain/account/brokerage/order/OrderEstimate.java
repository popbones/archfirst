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
package org.archfirst.bfoms.domain.account.brokerage.order;

import org.archfirst.common.money.Money;

/**
 * Contains order estimate and compliance information
 *
 * @author Naresh Bhatia
 */
public class OrderEstimate {
    private OrderCompliance compliance;
    private Money estimatedValue;
    private Money fees;
    private Money estimatedValueInclFees;

    // ----- Constructors -----
    public OrderEstimate(OrderCompliance compliance) {
        this.compliance = compliance;
    }
    
    public OrderEstimate(
            Money estimatedValue,
            Money fees,
            Money estimatedValueInclFees) {
        this.estimatedValue = estimatedValue;
        this.fees = fees;
        this.estimatedValueInclFees = estimatedValueInclFees;
    }

    // ----- Getters and Setters -----
    public OrderCompliance getCompliance() {
        return compliance;
    }
    // Allows Account to set this value
    public void setCompliance(OrderCompliance compliance) {
        this.compliance = compliance;
    }

    public Money getEstimatedValue() {
        return estimatedValue;
    }

    public Money getFees() {
        return fees;
    }

    public Money getEstimatedValueInclFees() {
        return estimatedValueInclFees;
    }
}