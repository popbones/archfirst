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
package test;

import java.math.BigDecimal;

import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

/**
 * DecimalQuantity
 *
 * @author Naresh Bhatia
 */
@XmlJavaTypeAdapter(DecimalQuantityAdapter.class)
public class DecimalQuantity {

    private BigDecimal value;

    // ----- Constructors -----
    public DecimalQuantity() {
        this.value = BigDecimal.ZERO;
    }

    public DecimalQuantity(String value) {
        this.value = new BigDecimal(value);
    }

    public DecimalQuantity(BigDecimal value) {
        this.value = value;
    }

    // ----- Getters and Setters -----
    public BigDecimal getValue() {
        return value;
    }
    private void setValue(BigDecimal value) {
        this.value = value;
    }

    // ----- Read-Only Operations -----
    /** Considers two quantities as equal only if they are equal in value and scale */
    public boolean equals(Object object) {
        if (this == object) {
            return true;
        }
        if (!(object instanceof DecimalQuantity)) {
            return false;
        }
        final DecimalQuantity that = (DecimalQuantity)object;
        return this.value.equals(that.getValue());
    }

    @Override
    public int hashCode() {
        return value.hashCode();
    }

}