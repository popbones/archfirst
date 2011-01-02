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
package org.archfirst.bfoms.domain.account;

import javax.persistence.Entity;
import javax.persistence.ManyToOne;
import javax.persistence.Transient;
import javax.validation.constraints.NotNull;

import org.joda.time.DateTime;

/**
 * Transfer
 *
 * @author Naresh Bhatia
 */
@Entity
public abstract class Transfer extends Transaction {
    private static final long serialVersionUID = 1L;

    private static final String TYPE = "Transfer";
    
    private BaseAccount otherAccount;

    // ----- Constructors -----
    protected Transfer() {
    }

    public Transfer(
            DateTime creationTime,
            BaseAccount otherAccount) {
        super(creationTime);
        this.otherAccount = otherAccount;
    }

    // ----- Getters and Setters -----
    @NotNull
    @ManyToOne
    public BaseAccount getOtherAccount() {
        return otherAccount;
    }
    private void setOtherAccount(BaseAccount otherAccount) {
        this.otherAccount = otherAccount;
    }

    @Override
    @Transient
    public String getType() {
        return TYPE;
    }
}