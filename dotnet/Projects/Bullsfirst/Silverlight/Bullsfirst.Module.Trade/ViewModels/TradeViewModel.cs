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
using System.ComponentModel;
using System.ComponentModel.Composition;
using System.Diagnostics;
using Archfirst.Framework.PrismHelpers;
using Bullsfirst.InterfaceOut.Oms.Domain;
using Bullsfirst.InterfaceOut.Oms.TradingServiceReference;
using Bullsfirst.Module.Trade.Interfaces;
using Microsoft.Practices.Prism.Commands;
using Microsoft.Practices.Prism.Events;
using Microsoft.Practices.Prism.Logging;

namespace Bullsfirst.Module.Trade.ViewModels
{
    [Export(typeof(ITradeViewModel))]
    [PartCreationPolicy(CreationPolicy.NonShared)]
    public class TradeViewModel : BaseDataValidator, ITradeViewModel
    {
        #region Construction

        [ImportingConstructor]
        public TradeViewModel(
            ILoggerFacade logger,
            IEventAggregator eventAggregator,
            Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.IMarketDataServiceAsync marketDataService,
            UserContext userContext,
            ReferenceData referenceData)
        {
            logger.Log("TradeViewModel.TradeViewModel()", Category.Debug, Priority.Low);
            _logger = logger;
            _eventAggregator = eventAggregator;
            _marketDataService = marketDataService;
            this.UserContext = userContext;
            this.ReferenceData = referenceData;

            _marketDataService.GetMarketPriceCompleted +=
                new EventHandler<InterfaceOut.Oms.MarketDataServiceReference.GetMarketPriceCompletedEventArgs>(GetMarketPriceCallback);
            PreviewOrderCommand = new DelegateCommand<object>(this.PreviewOrderExecute, this.CanPreviewOrderExecute);
            this.PropertyChanged += this.OnPropertyChanged;
            this.ValidateAll();
        }

        private void OnPropertyChanged(object sender, PropertyChangedEventArgs e)
        {
            this.Validate(e.PropertyName);
            this.PreviewOrderCommand.RaiseCanExecuteChanged();
        }

        #endregion

        #region PreviewOrderCommand

        public DelegateCommand<object> PreviewOrderCommand { get; set; }

        private bool CanPreviewOrderExecute(object dummyObject)
        {
            return this.CanCommandExecute();
        }

        private void PreviewOrderExecute(object dummyObject)
        {
            // Send PreviewOrderRequestEvent to create the PreviewOrder dialog
            PreviewOrderRequest request =
                new PreviewOrderRequest {
                    Symbol = Symbol,
                    ResponseHandler = PreviewOrderResponseHandler
                };
            _eventAggregator.GetEvent<PreviewOrderRequestEvent>().Publish(request);
        }

        private void PreviewOrderResponseHandler(PreviewOrderResponse response)
        {
            if (response.Result == false) return;

            // Place the order
            Debug.WriteLine("---> Place order");
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
                this.StatusMessage = e.Error.Message;
            }
            else
            {
                this.StatusMessage = null;
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
        }

        private void Validate(string propertyName)
        {
            switch (propertyName)
            {
            }
        }

        #endregion

        #region Members

        private ILoggerFacade _logger;
        private IEventAggregator _eventAggregator;
        private Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.IMarketDataServiceAsync _marketDataService;
        public UserContext UserContext { get; set; }
        public ReferenceData ReferenceData { get; set; }

        public string ViewTitle
        {
            get { return "Trade"; }
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