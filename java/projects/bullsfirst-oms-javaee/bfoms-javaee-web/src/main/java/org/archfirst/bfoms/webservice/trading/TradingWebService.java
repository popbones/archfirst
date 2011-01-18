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
package org.archfirst.bfoms.webservice.trading;

import java.math.BigDecimal;
import java.util.List;

import javax.inject.Inject;
import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebService;

import org.archfirst.bfoms.domain.account.Transaction;
import org.archfirst.bfoms.domain.account.external.ExternalAccountParams;

/**
 * TradingWebService
 *
 * @author Naresh Bhatia
 */
@WebService(targetNamespace = "http://archfirst.org/bfoms/tradingservice.wsdl", serviceName = "TradingService")
public class TradingWebService {

    @Inject
    private TradingTxnService tradingTxnService;
    
    // ----- Commands -----
    @WebMethod(operationName = "OpenNewAccount", action = "OpenNewAccount")
    public Long openNewAccount(
            @WebParam(name = "Username")
            String username,
            @WebParam(name = "AccountName")
            String accountName) {
        return tradingTxnService.openNewAccount(username, accountName);
    }

    @WebMethod(operationName = "AddExternalAccount", action = "AddExternalAccount")
    public Long addExternalAccount(
            @WebParam(name = "Username")
            String username,
            @WebParam(name = "ExternalAccountParams")
            ExternalAccountParams params) {
        return tradingTxnService.addExternalAccount(username, params);
    }

    @WebMethod(operationName = "TransferCash", action = "TransferCash")
    public void transferCash(
            @WebParam(name = "Amount")
            BigDecimal amount,
            @WebParam(name = "FromAccountId")
            Long fromAccountId,
            @WebParam(name = "ToAccountId")
            Long toAccountId) {
        tradingTxnService.transferCash(amount, fromAccountId, toAccountId);
    }

    // ----- Queries and Read-Only Operations -----
    @WebMethod(operationName = "GetTransactions", action = "GetTransactions")
    public List<Transaction> getTransactions(
            @WebParam(name = "AccountId")
            Long accountId) {
        return tradingTxnService.getTransactions(accountId);
    }
}