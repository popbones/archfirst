/* Copyright 2010 Archfirst
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
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.ComponentModel.Composition;
using Archfirst.Framework.Helpers;
using Bullsfirst.Infrastructure;
using Bullsfirst.InterfaceOut.Oms.Domain;
using Bullsfirst.InterfaceOut.Oms.TradingServiceReference;
using Bullsfirst.Module.TransactionHistory.Interfaces;
using Microsoft.Practices.Prism.Commands;
using Microsoft.Practices.Prism.Events;
using Microsoft.Practices.Prism.Logging;
using Microsoft.Practices.Prism.ViewModel;

namespace Bullsfirst.Module.TransactionHistory.ViewModels
{
    [Export(typeof(ITransactionHistoryViewModel))]
    [PartCreationPolicy(CreationPolicy.NonShared)]
    public class TransactionHistoryViewModel : NotificationObject, ITransactionHistoryViewModel
    {
        #region Construction

        [ImportingConstructor]
        public TransactionHistoryViewModel(
            ILoggerFacade logger,
            IEventAggregator eventAggregator,
            ITradingServiceAsync tradingService,
            UserContext userContext)
        {
            logger.Log("TransactionHistoryViewModel.TransactionHistoryViewModel()", Category.Debug, Priority.Low);
            _logger = logger;
            _eventAggregator = eventAggregator;
            _tradingService = tradingService;
            this.UserContext = userContext;
            this.Transactions = new ObservableCollection<TransactionSummary>();

            this.UpdateTransactionsCommand = new DelegateCommand<object>(this.UpdateTransactionsExecute);
            this.ResetFilterCommand = new DelegateCommand<object>(this.ResetFilterExecute);

            _tradingService.GetTransactionSummariesCompleted +=
                new EventHandler<GetTransactionSummariesCompletedEventArgs>(GetTransactionSummariesCallback);
            this.UserContext.PropertyChanged +=
                new PropertyChangedEventHandler(OnUserContextPropertyChanged);

            ResetFilter();
            SubscribeToEvents();
        }

        private void SubscribeToEvents()
        {
            // Don't use strong reference to delegate
            _eventAggregator.GetEvent<UserLoggedOutEvent>().Subscribe(OnUserLoggedOut, ThreadOption.UIThread, true);
        }

        #endregion

        #region UpdateTransactionsCommand

        public DelegateCommand<object> UpdateTransactionsCommand { get; set; }

        private void UpdateTransactionsExecute(object dummyObject)
        {
            UpdateTransactions();
        }

        private void UpdateTransactions()
        {
            TransactionCriteria criteria = new TransactionCriteria
            {
                AccountIdSpecified = true,
                AccountId = this.UserContext.SelectedAccount.Id,

                FromDateSpecified = FromDate.HasValue,
                FromDate = FromDate.HasValue ? FromDate.Value : DateTime.MinValue,

                ToDateSpecified = ToDate.HasValue,
                ToDate = ToDate.HasValue ? ToDate.Value : DateTime.MinValue,
            };
            _tradingService.GetTransactionSummariesAsync(criteria);
        }

        private void GetTransactionSummariesCallback(object sender, GetTransactionSummariesCompletedEventArgs e)
        {
            if (e.Error != null)
            {
                this.StatusMessage = e.Error.Message;
            }
            else
            {
                this.StatusMessage = null;
                Transactions.Clear();
                if (e.Result != null) // in case there are no transactions
                {
                    foreach (TransactionSummary transaction in e.Result)
                    {
                        Transactions.Add(transaction);
                    }
                }
            }
        }

        #endregion

        #region ResetFilterCommand

        public DelegateCommand<object> ResetFilterCommand { get; set; }

        private void ResetFilterExecute(object dummyObject)
        {
            ResetFilter();
        }

        private void ResetFilter()
        {
            FromDate = DateTime.Now;
            ToDate = DateTime.Now;

            Transactions.Clear();
        }

        #endregion

        #region Event Handlers

        public void OnUserLoggedOut(Empty empty)
        {
            this.ResetFilter();
        }

        public void OnUserContextPropertyChanged(Object sender, PropertyChangedEventArgs e)
        {
            // If selected account has changed then clear transactions because they are not relevant to the new account
            if (e.PropertyName.Equals("SelectedAccount"))
                Transactions.Clear();
        }

        #endregion

        #region Members

        private ILoggerFacade _logger;
        private IEventAggregator _eventAggregator;
        private ITradingServiceAsync _tradingService;
        public UserContext UserContext { get; set; }
        public ObservableCollection<TransactionSummary> Transactions { get; set; }

        public string ViewTitle
        {
            get { return "Transaction History"; }
        }

        private Nullable<DateTime> _fromDate;
        public Nullable<DateTime> FromDate
        {
            get { return _fromDate; }
            set
            {
                _fromDate = value;
                RaisePropertyChanged("FromDate");
            }
        }

        private Nullable<DateTime> _toDate;
        public Nullable<DateTime> ToDate
        {
            get { return _toDate; }
            set
            {
                _toDate = value;
                RaisePropertyChanged("ToDate");
            }
        }

        private string _statusMessage;
        public string StatusMessage
        {
            get { return _statusMessage; }
            set
            {
                _statusMessage = value;
                this.RaisePropertyChanged("StatusMessage");
            }
        }

        #endregion
    }
}