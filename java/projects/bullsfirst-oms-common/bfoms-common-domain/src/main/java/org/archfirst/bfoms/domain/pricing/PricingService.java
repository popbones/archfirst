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
package org.archfirst.bfoms.domain.pricing;

import java.util.Map;

import org.archfirst.common.money.Money;

/**
 * Provides market prices for all instruments.
 *
 * @author Naresh Bhatia
 */
public class PricingService {
    
    // ----- Commands -----
    public void updateMarketPrice(MarketPrice marketPrice) {
    }

    // ----- Queries and Read-Only Operations -----
    public Money getMarketPrice(Instrument instrument) {
        return null;
    }

    // ----- Getters and Setters -----
    private Map<Instrument, MarketPrice> getPriceMap() {
        return null;
    }

    // ----- Initializer -----
    private void initPriceMap() {
    }
}