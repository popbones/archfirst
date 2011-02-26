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
package org.archfirst.bfoms.interfaceout.exchange.marketdataadapter;

import java.util.ArrayList;
import java.util.List;

import org.archfirst.bfoms.domain.marketdata.MarketDataAdapter;
import org.archfirst.bfoms.domain.marketdata.MarketPrice;
import org.archfirst.common.money.Money;
import org.joda.time.DateTime;

/**
 * ExchangeMarketDataAdapter
 *
 * @author Naresh Bhatia
 */
public class ExchangeMarketDataAdapter implements MarketDataAdapter {

    @Override
    public List<MarketPrice> getMarketPrices() {

        List<MarketPrice> marketPrices = new ArrayList<MarketPrice>();
        marketPrices.add(new MarketPrice("CSCO", new Money("20"), new DateTime()));
        marketPrices.add(new MarketPrice("AAPL", new Money("300"), new DateTime()));
        return marketPrices;
    }
}