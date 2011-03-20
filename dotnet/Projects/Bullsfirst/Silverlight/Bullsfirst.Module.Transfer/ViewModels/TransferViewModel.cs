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
using Archfirst.Framework.PrismHelpers;
using Bullsfirst.Infrastructure;
using Bullsfirst.InterfaceOut.Oms.Domain;
using Bullsfirst.InterfaceOut.Oms.TradingServiceReference;
using Bullsfirst.Module.Transfer.Interfaces;
using Microsoft.Practices.Prism.Commands;
using Microsoft.Practices.Prism.Events;
using Microsoft.Practices.Prism.Logging;
using Microsoft.Practices.Prism.Regions;

namespace Bullsfirst.Module.Transfer.ViewModels
{
    [Export(typeof(ITransferViewModel))]
    [PartCreationPolicy(CreationPolicy.NonShared)]
    public class TransferViewModel : BaseDataValidator, ITransferViewModel
    {
        #region Construction

        [ImportingConstructor]
        public TransferViewModel(
            ILoggerFacade logger,
            IRegionManager regionManager,
            IEventAggregator eventAggregator,
            ITradingServiceAsync tradingService,
            Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.IMarketDataServiceAsync marketDataService,
            UserContext userContext,
            ReferenceData referenceData)
        {
            logger.Log("TransferViewModel.TransferViewModel()", Category.Debug, Priority.Low);
            _logger = logger;
            _regionManager = regionManager;
            _eventAggregator = eventAggregator;
            _tradingService = tradingService;
            _marketDataService = marketDataService;
            this.UserContext = userContext;
            this.ReferenceData = referenceData;

            _tradingService.TransferCashCompleted += new EventHandler<AsyncCompletedEventArgs>(TransferCallback);
            _tradingService.TransferSecuritiesCompleted += new EventHandler<AsyncCompletedEventArgs>(TransferCallback);
            _tradingService.AddExternalAccountCompleted += new EventHandler<AddExternalAccountCompletedEventArgs>(AddExternalAccountCallback);
            _marketDataService.GetMarketPriceCompleted +=
                new EventHandler<InterfaceOut.Oms.MarketDataServiceReference.GetMarketPriceCompletedEventArgs>(GetMarketPriceCallback);
            TransferCommand = new DelegateCommand<object>(this.TransferExecute, this.CanTransferExecute);
            AddExternalAccountCommand = new DelegateCommand<object>(this.AddExternalAccountExecute);
            this.PropertyChanged += this.OnPropertyChanged;
            this.ValidateAll();
        }

        private void OnPropertyChanged(object sender, PropertyChangedEventArgs e)
        {
            this.Validate(e.PropertyName);
            this.TransferCommand.RaiseCanExecuteChanged();
        }

        #endregion

        #region TransferCommand

        public DelegateCommand<object> TransferCommand { get; set; }

        private bool CanTransferExecute(object dummyObject)
        {
            return this.CanCommandExecute();
        }

        private void TransferExecute(object dummyObject)
        {
            if (TransferKind == TransferKind.Cash)
            {
                _tradingService.TransferCashAsync(
                    MoneyFactory.Create(Amount),
                    FromAccount.AccountSummary.Id,
                    ToAccount.AccountSummary.Id);
            }
            else
            {
                _tradingService.TransferSecuritiesAsync(
                    Symbol,
                    Quantity,
                    MoneyFactory.Create(PricePaidPerShare),
                    FromAccount.AccountSummary.Id,
                    ToAccount.AccountSummary.Id);
            }
        }

        private void TransferCallback(object sender, AsyncCompletedEventArgs e)
        {
            if (e.Error != null)
            {
                // TODO: WCF on Silverlight does not get faults correctly
                // this.StatusMessage = e.Error.Message;
                this.StatusMessage = "Operation failed";
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

                // Send AccountUpdatedEvent and switch to positions page
                _eventAggregator.GetEvent<AccountUpdatedEvent>().Publish(Empty.Value);
                _regionManager.RequestNavigate(
                    RegionNames.LoggedInUserRegion,
                    new Uri(ViewNames.PositionsView, UriKind.Relative));
            }
        }

        #endregion

        #region AddExternalAccountCommand

        public DelegateCommand<object> AddExternalAccountCommand { get; set; }

        private void AddExternalAccountExecute(object dummyObject)
        {
            // Send AddExternalAccountRequestEvent to create the CreateNewAccount dialog
            AddExternalAccountRequest request =
                new AddExternalAccountRequest { ResponseHandler = AddExternalAccountResponseHandler };
            _eventAggregator.GetEvent<AddExternalAccountRequestEvent>().Publish(request);
        }

        private void AddExternalAccountResponseHandler(AddExternalAccountResponse response)
        {
            if (response.Result == false) return;

            // Add the requested account
            _tradingService.AddExternalAccountAsync(new ExternalAccountParams
            {
                Name = response.AccountName,
                RoutingNumber = response.RoutingNumber,
                AccountNumber = response.AccountNumber
            });
        }

        private void AddExternalAccountCallback(object sender, AddExternalAccountCompletedEventArgs e)
        {
            if (e.Error != null)
            {
                this.StatusMessage = e.Error.Message;
            }
            else
            {
                this.StatusMessage = null;

                // Send AccountCreatedEvent
                _eventAggregator.GetEvent<AccountCreatedEvent>().Publish(Empty.Value);
            }
        }

        #endregion

        #region UpdateLastTrade

        public void UpdateLastTrade()
        {
            if (_symbol.Length > 0)
                _marketDataService.GetMarketPriceAsync(_symbol);
            else
                LastTrade = null;
        }

        private void GetMarketPriceCallback(
            object sender,
            Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.GetMarketPriceCompletedEventArgs e)
        {
            if (e.Error != null)
            {
                // this.StatusMessage = e.Error.Message;
            }
            else
            {
                // this.StatusMessage = null;
                LastTrade = new Money
                {
                    Amount = e.Result.Price.Amount,
                    Currency = e.Result.Price.Currency
                };
            }
        }

        #endregion

        #region IDataErrorInfo implementation

        private void ValidateAll()
        {
            this.Validate("FromAccount");
            this.Validate("ToAccount");

            if (TransferKind == TransferKind.Cash)
            {
                this.Validate("Amount");
                this.ClearError("Symbol");
                this.ClearError("Quantity");
                this.ClearError("PricePaidPerShare");
            }
            else
            {
                this.ClearError("Amount");
                this.Validate("Symbol");
                this.Validate("Quantity");
                this.Validate("PricePaidPerShare");
            }
        }

        private void Validate(string propertyName)
        {
            switch (propertyName)
            {
                case "TransferKind":
                    ValidateAll();
                    break;

                case "FromAccount":
                    if (FromAccount == null)
                        this["FromAccount"] = "Please select the account to transfer from";
                    else
                        this.ClearError("FromAccount");
                    break;

                case "ToAccount":
                    if (ToAccount == null)
                        this["ToAccount"] = "Please select the account to transfer to";
                    else
                        this.ClearError("ToAccount");
                    break;

                case "Amount":
                    if (Amount <= 0)
                        this["Amount"] = "Please enter the amount to transfer";
                    else
                        this.ClearError("Amount");
                    break;

                case "Symbol":
                    if (string.IsNullOrEmpty(this.Symbol) || this.Symbol.Trim().Length == 0)
                        this["Symbol"] = "Please enter a security to transfer";
                    else
                        this.ClearError("Symbol");
                    break;

                case "Quantity":
                    if (Quantity <= 0)
                        this["Quantity"] = "Please enter the quantity to transfer";
                    else
                        this.ClearError("Quantity");
                    break;

                case "PricePaidPerShare":
                    if (PricePaidPerShare <= 0)
                        this["PricePaidPerShare"] = "Please enter the price paid per share";
                    else
                        this.ClearError("PricePaidPerShare");
                    break;
            }
        }

        #endregion

        #region Members

        private ILoggerFacade _logger;
        private IRegionManager _regionManager;
        private IEventAggregator _eventAggregator;
        private ITradingServiceAsync _tradingService;
        private Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.IMarketDataServiceAsync _marketDataService;

        public UserContext UserContext { get; set; }
        public ReferenceData ReferenceData { get; set; }

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

        private Money _lastTrade;
        public Money LastTrade
        {
            get { return _lastTrade; }
            set
            {
                if (_lastTrade != value)
                {
                    _lastTrade = value;
                    this.RaisePropertyChanged("LastTrade");
                }
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