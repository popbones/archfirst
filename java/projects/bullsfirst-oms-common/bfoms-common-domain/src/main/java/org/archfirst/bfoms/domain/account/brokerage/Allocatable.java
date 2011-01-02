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

import org.archfirst.common.quantity.DecimalQuantity;

/**
 * An entity that can be allocated to various lots, e.g. a Trade or
 * a SecuritiesTransfer.
 *
 * @author Naresh Bhatia
 */
public interface Allocatable {

    /**
     * Allocates the specified quantity to a lot
     * @param quantity
     * @param lot
     */
    void allocate(DecimalQuantity quantity, Lot lot);
}