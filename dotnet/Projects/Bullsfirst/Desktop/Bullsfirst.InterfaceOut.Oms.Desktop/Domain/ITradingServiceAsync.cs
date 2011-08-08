/* Copyright 2011 Archfirst
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
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel.Composition;
using Bullsfirst.InterfaceOut.Oms.Security;
using System.ComponentModel;

namespace Bullsfirst.InterfaceOut.Oms.TradingServiceReference
{
    public interface ITradingServiceAsync : TradingWebService
    {
        void OpenNewAccountAsync(string AccountName);
        void AddExternalAccountAsync(ExternalAccountParams ExternalAccountParams);
        void ChangeAccountNameAsync(long AccountId, string NewName);
        void TransferCashAsync(Money Amount, long FromAccountId, long ToAccountId);
        void TransferSecuritiesAsync(
        string Symbol, decimal Quantity, Money PricePaidPerShare,
        long FromAccountId, long ToAccountId);
        void PlaceOrderAsync(long BrokerageAccountId, OrderParams OrderParams);
        void CancelOrderAsync(long OrderId);
        void GetBrokerageAccountSummariesAsync();
        void GetExternalAccountSummariesAsync();
        void GetOrdersAsync(OrderCriteria OrderCriteria);
        void GetOrderEstimateAsync(long BrokerageAccountId, OrderParams OrderParams);
        void GetTransactionSummariesAsync(TransactionCriteria TransactionCriteria);

        event EventHandler<OpenNewAccountCompletedEventArgs> OpenNewAccountCompleted;
        event EventHandler<AddExternalAccountCompletedEventArgs> AddExternalAccountCompleted;
        event EventHandler<AsyncCompletedEventArgs> ChangeAccountNameCompleted;
        event EventHandler<AsyncCompletedEventArgs> TransferCashCompleted;
        event EventHandler<AsyncCompletedEventArgs> TransferSecuritiesCompleted;
        event EventHandler<PlaceOrderCompletedEventArgs> PlaceOrderCompleted;
        event EventHandler<AsyncCompletedEventArgs> CancelOrderCompleted;
        event EventHandler<GetBrokerageAccountSummariesCompletedEventArgs> GetBrokerageAccountSummariesCompleted;
        event EventHandler<GetExternalAccountSummariesCompletedEventArgs> GetExternalAccountSummariesCompleted;
        event EventHandler<GetOrdersCompletedEventArgs> GetOrdersCompleted;
        event EventHandler<GetOrderEstimateCompletedEventArgs> GetOrderEstimateCompleted;
        event EventHandler<GetTransactionSummariesCompletedEventArgs> GetTransactionSummariesCompleted;
    }

    [Export(typeof(ITradingServiceAsync))]
    [PartCreationPolicy(CreationPolicy.NonShared)]
    public partial class TradingWebServiceClient : ITradingServiceAsync
    {
        [ImportingConstructor]
        public TradingWebServiceClient(AuthenticationBehavior authenticationBehavior)
        {
            this.Endpoint.Behaviors.Add(authenticationBehavior);
        }
    }
}
