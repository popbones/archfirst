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
import java.util.Map;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.jws.HandlerChain;
import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebResult;
import javax.jws.WebService;
import javax.xml.ws.WebServiceContext;
import javax.xml.ws.handler.MessageContext;

import org.archfirst.bfoms.domain.account.brokerage.AccountSummary;
import org.archfirst.bfoms.domain.account.brokerage.order.OrderParams;
import org.archfirst.bfoms.domain.account.external.ExternalAccountParams;
import org.archfirst.common.money.Money;

/**
 * TradingWebService
 *
 * @author Naresh Bhatia
 */
@WebService(targetNamespace = "http://archfirst.org/bfoms/tradingservice.wsdl", serviceName = "TradingService")
@HandlerChain(file = "handler-chain.xml")
public class TradingWebService {

    @Inject private TradingTxnService tradingTxnService;
    @Resource private WebServiceContext wsContext;
    
    // ----- Commands -----
    @WebMethod(operationName = "OpenNewAccount", action = "OpenNewAccount")
    @WebResult(name = "AccountId")
    public Long openNewAccount(
            @WebParam(name = "AccountName")
            String accountName) {
        return tradingTxnService.openNewAccount(getUsername(), accountName);
    }

    @WebMethod(operationName = "AddExternalAccount", action = "AddExternalAccount")
    @WebResult(name = "AccountId")
    public Long addExternalAccount(
            @WebParam(name = "ExternalAccountParams")
            ExternalAccountParams params) {
        return tradingTxnService.addExternalAccount(getUsername(), params);
    }

    @WebMethod(operationName = "ChangeAccountName", action = "ChangeAccountName")
    public void changeAccountName(
            @WebParam(name = "AccountId")
            Long accountId,
            @WebParam(name = "NewName")
            String newName) {
        tradingTxnService.changeAccountName(accountId, newName);
    }
    
    @WebMethod(operationName = "TransferCash", action = "TransferCash")
    public void transferCash(
            @WebParam(name = "Amount")
            Money amount,
            @WebParam(name = "FromAccountId")
            Long fromAccountId,
            @WebParam(name = "ToAccountId")
            Long toAccountId) {
        tradingTxnService.transferCash(getUsername(), amount, fromAccountId, toAccountId);
    }

    @WebMethod(operationName = "TransferSecurities", action = "TransferSecurities")
    public void transferSecurities(
            @WebParam(name = "Symbol")
            String symbol,
            @WebParam(name = "Quantity")
            BigDecimal quantity,
            @WebParam(name = "PricePaidPerShare")
            Money pricePaidPerShare,
            @WebParam(name = "FromAccountId")
            Long fromAccountId,
            @WebParam(name = "ToAccountId")
            Long toAccountId) {
        tradingTxnService.transferSecurities(
                getUsername(), symbol, quantity, pricePaidPerShare,
                fromAccountId, toAccountId);
    }

    @WebMethod(operationName = "PlaceOrder", action = "PlaceOrder")
    @WebResult(name = "OrderId")
    public Long placeOrder(
            @WebParam(name = "BrokerageAccountId")
            Long brokerageAccountId,
            @WebParam(name = "OrderParams")
            OrderParams orderParams) {
        return tradingTxnService.placeOrder(
                getUsername(), brokerageAccountId, orderParams);
    }
    
    // ----- Queries and Read-Only Operations -----
    @WebMethod(operationName = "GetBrokerageAccountSummaries", action = "GetBrokerageAccountSummaries")
    @WebResult(name = "AccountSummary")
    public List<AccountSummary> getBrokerageAccountSummaries() {
        return this.tradingTxnService.getBrokerageAccountSummaries(getUsername());
    }

    // ----- Helper Methods -----
    private static final String USERNAME_KEY = "username";
    
    private String getUsername() {
        MessageContext msgContext = wsContext.getMessageContext();
        @SuppressWarnings("unchecked")
        Map<String, List<String>> http_headers =
            (Map<String, List<String>>)msgContext.get(MessageContext.HTTP_REQUEST_HEADERS);
        List<String> usernameList = http_headers.get(USERNAME_KEY);
        return usernameList.get(0);
    }
}