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

import java.util.EnumSet;
import java.util.HashMap;
import java.util.Map;

/**
 * OrderCompliance
 * 
 * @author Naresh Bhatia
 */
public enum OrderCompliance {
    Compliant("COMPLNT", "Compliant"),
    NonCompliant("NON_COMPLNT", "Non Compliant"),
    LimitOrderWithNoLimitPrice("NOLMTPRC", "Limit Order With No Limit Price"),
    InsufficientFunds("INSFFUND", "Insufficient Funds"),
    InsufficientQuantity("INSFQTY", "Insufficient Quantity");
    
    private final String identifier;
    private final String displayString;
    
    private static Map<String, OrderCompliance> identifiers =
        new HashMap<String, OrderCompliance>();
    
    static {
        for (OrderCompliance compliance : EnumSet.allOf(OrderCompliance.class)) {
            identifiers.put(compliance.toIdentifier(), compliance);
        }
    }
    
    private OrderCompliance(String identifier, String displayString) {
        this.identifier = identifier;
        this.displayString = displayString;
    }
    
    public String toIdentifier() {
        return this.identifier;
    }
    
    public static final OrderCompliance fromIdentifier(String identifier) {
        return identifiers.get(identifier);
    }

    public String getDisplayString() {
        return displayString;
    }
}