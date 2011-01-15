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
package org.archfirst.bfoms.spec.account;

import javax.inject.Inject;

import org.archfirst.bfoms.domain.account.brokerage.BrokerageAccountService;
import org.archfirst.bfoms.domain.security.RegistrationRequest;
import org.archfirst.bfoms.domain.security.SecurityService;
import org.archfirst.common.springtest.AbstractTransactionalSpecTest;
import org.springframework.test.context.ContextConfiguration;

/**
 * OpenNewAccountTest
 *
 * @author Naresh Bhatia
 */
@ContextConfiguration(locations={"classpath:/org/archfirst/bfoms/spec/applicationContext.xml"})
public class OpenNewAccountTest extends AbstractTransactionalSpecTest {

    private static String FIRST_NAME = "John";
    private static String LAST_NAME = "Smith";
    private static String USERNAME = "jsmith";
    private static String PASSWORD = "cool";
    private static String ACCOUNT_NAME = "Brokerage Account";
    
    @Inject private SecurityService securityService;
    @Inject private BrokerageAccountService brokerageAccountService;

    public void openNewAccount() throws Exception {
        securityService.registerUser(
                new RegistrationRequest(FIRST_NAME, LAST_NAME, USERNAME, PASSWORD));
        Long accountId =
            brokerageAccountService.openNewAccount(USERNAME, ACCOUNT_NAME);
        brokerageAccountService.findAccount(accountId);
    }
}