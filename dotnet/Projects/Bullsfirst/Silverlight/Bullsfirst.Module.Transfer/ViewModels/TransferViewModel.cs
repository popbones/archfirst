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
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.Composition;
using System.Windows.Controls;
using Archfirst.Framework.Helpers;
using Bullsfirst.Infrastructure;
using Bullsfirst.InterfaceOut.Oms.Domain;
using Bullsfirst.InterfaceOut.Oms.TradingServiceReference;
using Bullsfirst.Module.Transfer.Interfaces;
using Microsoft.Practices.Prism.Commands;
using Microsoft.Practices.Prism.Events;
using Microsoft.Practices.Prism.Logging;
using Microsoft.Practices.Prism.Regions;
using Microsoft.Practices.Prism.ViewModel;

namespace Bullsfirst.Module.Transfer.ViewModels
{
    [Export(typeof(ITransferViewModel))]
    [PartCreationPolicy(CreationPolicy.NonShared)]
    public class TransferViewModel : NotificationObject, ITransferViewModel, IDataErrorInfo
    {
        #region Construction

        [ImportingConstructor]
        public TransferViewModel(
            ILoggerFacade logger,
            IRegionManager regionManager,
            IEventAggregator eventAggregator,
            ITradingServiceAsync tradingService,
            UserContext userContext)
        {
            logger.Log("TransferViewModel.TransferViewModel()", Category.Debug, Priority.Low);
            _logger = logger;
            _regionManager = regionManager;
            _eventAggregator = eventAggregator;
            _tradingService = tradingService;
            this.UserContext = userContext;

            _tradingService.TransferCashCompleted += new EventHandler<AsyncCompletedEventArgs>(TransferCallback);
            _tradingService.TransferSecuritiesCompleted += new EventHandler<AsyncCompletedEventArgs>(TransferCallback);
            TransferCommand = new DelegateCommand<object>(this.TransferExecute, this.CanTransferExecute);
            this.PropertyChanged += this.OnPropertyChanged;
            this.Validate();
        }

        private void OnPropertyChanged(object sender, PropertyChangedEventArgs e)
        {
            this.Validate();
            this.TransferCommand.RaiseCanExecuteChanged();
        }

        #endregion

        #region TransferCommand

        public DelegateCommand<object> TransferCommand { get; set; }

        private bool CanTransferExecute(object dummyObject)
        {
            return _errors.Count == 0;
        }

        private void TransferExecute(object dummyObject)
        {
            if (TransferKind == TransferKind.Cash)
            {
                _tradingService.TransferCashAsync(
                    new Money { Amount = Amount, Currency = "USD" },
                    FromAccount.AccountSummary.Id,
                    ToAccount.AccountSummary.Id);
            }
            else
            {
                _tradingService.TransferSecuritiesAsync(
                    Symbol,
                    Quantity,
                    new Money { Amount = PricePaidPerShare, Currency = "USD" },
                    FromAccount.AccountSummary.Id,
                    ToAccount.AccountSummary.Id);
            }
        }

        private void TransferCallback(object sender, AsyncCompletedEventArgs e)
        {
            if (e.Error != null)
            {
                this.StatusMessage = e.Error.Message;
            }
            else
            {
                this.StatusMessage = null;

                // Change account selection as appropriate
                if (ToAccount.AccountSummary is BrokerageAccountSummary)
                {
                    UserContext.SelectedAccount =
                        (BrokerageAccountSummary)(ToAccount.AccountSummary);
                }
                else if (FromAccount.AccountSummary is BrokerageAccountSummary)
                {
                    UserContext.SelectedAccount =
                        (BrokerageAccountSummary)(FromAccount.AccountSummary);
                }

                // Send AccountUpdatedEvent and switch to transactions page
                _eventAggregator.GetEvent<AccountUpdatedEvent>().Publish(Empty.Value);
                _regionManager.RequestNavigate(
                    RegionNames.LoggedInUserRegion,
                    new Uri(ViewNames.TransactionHistoryView, UriKind.Relative));
            }
        }

        #endregion

        #region AddExternalAccountCommand

        public DelegateCommand<object> AddExternalAccountCommand { get; set; }

        #endregion

        #region IDataErrorInfo implementation

        // Map column name to error string
        private readonly IDictionary<string, string> _errors = new Dictionary<string, string>();

        public string Error
        {
            get { throw new NotImplementedException(); }
        }

        public string this[string columnName]
        {
            get
            {
                if (_errors.ContainsKey(columnName))
                {
                    return _errors[columnName];
                }

                return null;
            }

            set
            {
                _errors[columnName] = value;
            }
        }

        // Validates all fields and updates _errors
        // This approach was necessary because OnPropertyChanged (and hence LoginCommand.RaiseCanExecuteChanged)
        // fires before this[string columnName] is fired by the IDataErrorInfo interface
        private void Validate()
        {
            if (FromAccount == null)
                this["FromAccount"] = "Please select the account to transfer from";
            else
                this.ClearError("FromAccount");

            if (ToAccount == null)
                this["ToAccount"] = "Please select the account to transfer to";
            else
                this.ClearError("ToAccount");

            if (TransferKind == TransferKind.Cash)
            {
                if (Amount <= 0)
                    this["Amount"] = "Please enter the amount to transfer";
                else
                    this.ClearError("Amount");

                this.ClearError("Symbol");
                this.ClearError("Quantity");
                this.ClearError("PricePaidPerShare");
            }
            else
            {
                this.ClearError("Amount");

                if (string.IsNullOrEmpty(this.Symbol) || this.Symbol.Trim().Length == 0)
                    this["Symbol"] = "Please enter a security to transfer";
                else
                    this.ClearError("Symbol");

                if (Quantity <= 0)
                    this["Quantity"] = "Please enter the quantity to transfer";
                else
                    this.ClearError("Quantity");

                if (PricePaidPerShare <= 0)
                    this["PricePaidPerShare"] = "Please enter the price paid per share";
                else
                    this.ClearError("PricePaidPerShare");
            }
        }

        private void ClearError(string columnName)
        {
            if (_errors.ContainsKey(columnName))
            {
                _errors.Remove(columnName);
            }
        }

        #endregion

        #region Members

        private ILoggerFacade _logger;
        private IRegionManager _regionManager;
        private IEventAggregator _eventAggregator;
        private ITradingServiceAsync _tradingService;

        public UserContext UserContext { get; set; }

        public string ViewTitle
        {
            get { return "Transfer"; }
        }

        private TransferKind _transferKind = TransferKind.Cash;
        public TransferKind TransferKind
        {
            get { return _transferKind; }
            set
            {
                // The Equals check below is important. Without it the value of transferKind
                // bounces a couple of times and settles on the wrong value.
                if (!_transferKind.Equals(value))
                {
                    _transferKind = value;
                    RaisePropertyChanged("TransferKind");
                }
            }
        }

        private BaseAccountWrapper _fromAccount;
        public BaseAccountWrapper FromAccount
        {
            get { return _fromAccount; }
            set
            {
                _fromAccount = value;
                this.RaisePropertyChanged("FromAccount");
            }
        }

        private BaseAccountWrapper _toAccount;
        public BaseAccountWrapper ToAccount
        {
            get { return _toAccount; }
            set
            {
                _toAccount = value;
                this.RaisePropertyChanged("ToAccount");
            }
        }

        private decimal _amount;
        public decimal Amount
        {
            get { return _amount; }
            set
            {
                _amount = value;
                this.RaisePropertyChanged("Amount");
            }
        }

        private string _symbol;
        public string Symbol
        {
            get { return _symbol; }
            set
            {
                _symbol = value;
                this.RaisePropertyChanged("Symbol");
            }
        }

        private decimal _quantity;
        public decimal Quantity
        {
            get { return _quantity; }
            set
            {
                _quantity = value;
                this.RaisePropertyChanged("Quantity");
            }
        }

        private decimal _pricePaidPerShare;
        public decimal PricePaidPerShare
        {
            get { return _pricePaidPerShare; }
            set
            {
                _pricePaidPerShare = value;
                this.RaisePropertyChanged("PricePaidPerShare");
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