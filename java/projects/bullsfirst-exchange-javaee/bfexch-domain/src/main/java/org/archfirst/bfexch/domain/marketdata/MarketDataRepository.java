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
package org.archfirst.bfexch.domain.marketdata;

import java.util.List;

import org.archfirst.common.domain.BaseRepository;

/**
 * MarketDataRepository
 *
 * @author Naresh
 */
public class MarketDataRepository extends BaseRepository {

    public List<MarketPrice> findAllMarketPrices() {
        return this.entityManager
            .createQuery("SELECT m FROM MarketPrice m", MarketPrice.class)
            .getResultList();
    }
    
    public MarketPrice findMarketPrice(String symbol) {
        return this.entityManager
            .createQuery(
                    "SELECT m FROM MarketPrice m " +
                    "where m.symbol = :symbol", MarketPrice.class)
            .setParameter("symbol", symbol)
            .getSingleResult();
    }
}