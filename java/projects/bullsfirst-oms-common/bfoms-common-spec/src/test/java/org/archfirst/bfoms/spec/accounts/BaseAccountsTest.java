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
package org.archfirst.bfoms.spec.accounts;

import javax.inject.Inject;

import org.archfirst.bfoms.domain.account.BaseAccountService;
import org.archfirst.bfoms.domain.account.brokerage.BrokerageAccountService;
import org.archfirst.bfoms.domain.account.external.ExternalAccountParams;
import org.archfirst.bfoms.domain.account.external.ExternalAccountService;
import org.archfirst.bfoms.domain.security.RegistrationRequest;
import org.archfirst.bfoms.domain.security.SecurityService;
import org.archfirst.common.springtest.AbstractTransactionalSpecTest;
import org.springframework.test.context.ContextConfiguration;

/**
 * BaseAccountsTest
 *
 * @author Naresh
 */
@ContextConfiguration(locations={"classpath:/org/archfirst/bfoms/spec/applicationContext.xml"})
public abstract class BaseAccountsTest extends AbstractTransactionalSpecTest  {

    private static String FIRST_NAME1 = "John";
    private static String LAST_NAME1 = "Smith";
    private static String USERNAME1 = "jsmith";
    private static String PASSWORD1 = "cool";
    private static String BROKERAGE_ACCOUNT_NAME1 = "Brokerage Account 1";
    private static String EXTERNAL_ACCOUNT_NAME1 = "External Account 1";
    private static String EXTERNAL_ROUTING_NUMBER1 = "011000123";
    private static String EXTERNAL_ACCOUNT_NUMBER1 = "0157-8965-2278";
    
    @Inject protected BaseAccountService baseAccountService;
    @Inject protected BrokerageAccountService brokerageAccountService;
    @Inject protected ExternalAccountService externalAccountService;
    @Inject protected SecurityService securityService;
    
    protected Long brokerageAccount1Id;
    protected Long externalAccount1Id;
    
    public void createUser1() throws Exception {
        securityService.registerUser(
                new RegistrationRequest(FIRST_NAME1, LAST_NAME1, USERNAME1, PASSWORD1));
    }

    public void createBrokerageAccount1() throws Exception {
        brokerageAccount1Id = brokerageAccountService.openNewAccount(
                USERNAME1, BROKERAGE_ACCOUNT_NAME1);
    }

    public void createExternalAccount1() throws Exception {
        ExternalAccountParams params = new ExternalAccountParams(
                EXTERNAL_ACCOUNT_NAME1,
                EXTERNAL_ROUTING_NUMBER1,
                EXTERNAL_ACCOUNT_NUMBER1);
        externalAccount1Id = externalAccountService.addExternalAccount(
                USERNAME1, params);
    }
}