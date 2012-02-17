/**
 * Copyright 2012 Archfirst
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
package org.archfirst.bfoms.infra.app;

import java.math.BigDecimal;

import org.archfirst.common.quantity.DecimalQuantity;
import org.dozer.DozerConverter;

/**
 * DecimalQuantityConverter
 *
 * @author Naresh Bhatia
 */
public class DecimalQuantityConverter extends DozerConverter<DecimalQuantity, BigDecimal> {

    public DecimalQuantityConverter() {
        super(DecimalQuantity.class, BigDecimal.class);
    }
    
    @Override
    public BigDecimal convertTo(DecimalQuantity src, BigDecimal dst) {
        return (src == null) ? null : src.getValue();
    }

    @Override
    public DecimalQuantity convertFrom(BigDecimal src, DecimalQuantity dst) {
        return (src == null) ? null : new DecimalQuantity(src);
    }
}