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
using Archfirst.Framework.Helpers;
using Archfirst.Framework.PrismHelpers;
using Bullsfirst.Infrastructure;
using Bullsfirst.InterfaceOut.Oms.Domain;
using Bullsfirst.InterfaceOut.Oms.TradingServiceReference;
using Bullsfirst.Module.Trade.Interfaces;
using Microsoft.Practices.Prism.Commands;
using Microsoft.Practices.Prism.Events;
using Microsoft.Practices.Prism.Logging;
using Microsoft.Practices.Prism.Regions;

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
            IRegionManager regionManager,
            IEventAggregator eventAggregator,
            Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.IMarketDataServiceAsync marketDataService,
            ITradingServiceAsync tradingService,
            UserContext userContext,
            ReferenceData referenceData)
        {
            logger.Log("TradeViewModel.TradeViewModel()", Category.Debug, Priority.Low);
            _logger = logger;
            _regionManager = regionManager;
            _eventAggregator = eventAggregator;
            _marketDataService = marketDataService;
            _tradingService = tradingService;
            this.UserContext = userContext;
            this.ReferenceData = referenceData;

            _marketDataService.GetMarketPriceCompleted +=
                new EventHandler<InterfaceOut.Oms.MarketDataServiceReference.GetMarketPriceCompletedEventArgs>(GetMarketPriceCallback);
            _tradingService.GetOrderEstimateCompleted +=
                new EventHandler<GetOrderEstimateCompletedEventArgs>(GetOrderEstimateCallback);
            _tradingService.PlaceOrderCompleted +=
                new EventHandler<PlaceOrderCompletedEventArgs>(PlaceOrderCallback);
            PreviewOrderCommand = new DelegateCommand<object>(this.PreviewOrderExecute, this.CanPreviewOrderExecute);
            this.PropertyChanged += this.OnPropertyChanged;
            this.ValidateAll();
            SubscribeToEvents();
        }

        private void OnPropertyChanged(object sender, PropertyChangedEventArgs e)
        {
            this.Validate(e.PropertyName);
            this.PreviewOrderCommand.RaiseCanExecuteChanged();
        }

        private void SubscribeToEvents()
        {
            // Don't use strong reference to delegate
            _eventAggregator.GetEvent<PopulateOrderEvent>().Subscribe(OnPopulateOrder, ThreadOption.UIThread, true);
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
            // Before showing the preview order dialog, get an order estimate
            _tradingService.GetOrderEstimateAsync(UserContext.SelectedAccount.Id, assembleOrderParams());
        }

        private void GetOrderEstimateCallback(object sender, GetOrderEstimateCompletedEventArgs e)
        {
            if (e.Error != null)
            {
                this.StatusMessage = e.Error.Message;
            }
            else if (e.Result.Compliance != OrderCompliance.Compliant)
            {
                this.StatusMessage = e.Result.Compliance.ToString();
            }
            else
            {
                this.StatusMessage = null;

                // Send PreviewOrderRequestEvent to create the PreviewOrder dialog
                PreviewOrderRequest request =
                    new PreviewOrderRequest
                    {
                        UserContext = UserContext,
                        OrderParams = assembleOrderParams(),
                        LastTrade = LastTrade,
                        OrderEstimate = e.Result,
                        ResponseHandler = PreviewOrderResponseHandler
                    };
                _eventAggregator.GetEvent<PreviewOrderRequestEvent>().Publish(request);
            }
        }

        private void PreviewOrderResponseHandler(PreviewOrderResponse response)
        {
            if (response.Result == false) return;

            // Place the order
            _tradingService.PlaceOrderAsync(UserContext.SelectedAccount.Id, assembleOrderParams());
        }

        private void PlaceOrderCallback(object sender, PlaceOrderCompletedEventArgs e)
        {
            if (e.Error != null)
            {
                this.StatusMessage = e.Error.Message;
            }
            else
            {
                this.StatusMessage = null;

                // Send OrderPlacedEvent and switch to orders page
                _eventAggregator.GetEvent<OrderPlacedEvent>().Publish(Empty.Value);
                _regionManager.RequestNavigate(
                    RegionNames.LoggedInUserRegion,
                    new Uri(ViewNames.OrdersView, UriKind.Relative));
            }
        }

        private OrderParams assembleOrderParams()
        {
            return new OrderParams
            {
                Side = Side,
                Symbol = Symbol,
                Quantity = Quantity,
                Type = Type,
                LimitPrice = getEffectiveLimitPrice(),
                Term = Term,
                AllOrNone = AllOrNone
            };
        }

        /// <summary>
        /// Returns LimitPrice or null depending on order type
        /// </summary>
        private Money getEffectiveLimitPrice()
        {
            return (Type == OrderType.Market) ? null : MoneyFactory.Create(LimitPrice);
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

        #region OnPopulateOrder

        private void OnPopulateOrder(PopulateOrderEventArgs args)
        {
            Symbol = args.Symbol;
            Side = args.Side;
            Quantity = Convert.ToInt32(args.Quantity);
        }

        #endregion // OnPopulateOrder

        #region IDataErrorInfo implementation

        private void ValidateAll()
        {
            this.Validate("Symbol");
            this.Validate("Quantity");
        }

        private void Validate(string propertyName)
        {
            switch (propertyName)
            {
                case "Symbol":
                    if (string.IsNullOrEmpty(this.Symbol) || this.Symbol.Trim().Length == 0)
                        this["Symbol"] = "Please enter a security to trade";
                    else
                        this.ClearError("Symbol");
                    break;

                case "Quantity":
                    if (Quantity <= 0)
                        this["Quantity"] = "Please enter the quantity to trade";
                    else
                        this.ClearError("Quantity");
                    break;

                case "Type":
                    if (Type == OrderType.Market)
                    {
                        this.ClearError("LimitPrice");
                    }
                    else
                    {
                        this.Validate("LimitPrice");
                    }
                    break;
                case "LimitPrice":
                    if (LimitPrice <= 0)
                        this["LimitPrice"] = "Please enter a limit price";
                    else
                        this.ClearError("LimitPrice");
                    break;
            }
        }

        #endregion

        #region Members

        private ILoggerFacade _logger;
        private IRegionManager _regionManager;
        private IEventAggregator _eventAggregator;
        private Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.IMarketDataServiceAsync _marketDataService;
        private ITradingServiceAsync _tradingService;
        public UserContext UserContext { get; set; }
        public ReferenceData ReferenceData { get; set; }

        public string ViewTitle
        {
            get { return "Trade"; }
        }

        private OrderSide _side = OrderSide.Buy;
        public OrderSide Side
        {
            get { return _side; }
            set
            {
                _side = value;
                RaisePropertyChanged("Side");
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

        private int _quantity;
        public int Quantity
        {
            get { return _quantity; }
            set
            {
                _quantity = value;
                RaisePropertyChanged("Quantity");
            }
        }

        private OrderType _type = OrderType.Market;
        public OrderType Type
        {
            get { return _type; }
            set
            {
                _type = value;
                RaisePropertyChanged("Type");
            }
        }

        private decimal _limitPrice;
        public decimal LimitPrice
        {
            get { return _limitPrice; }
            set
            {
                _limitPrice = value;
                RaisePropertyChanged("LimitPrice");
            }
        }

        private OrderTerm _term = OrderTerm.GoodForTheDay;
        public OrderTerm Term
        {
            get { return _term; }
            set
            {
                _term = value;
                RaisePropertyChanged("Term");
            }
        }

        private bool _allOrNone = false;
        public bool AllOrNone
        {
            get { return _allOrNone; }
            set
            {
                _allOrNone = value;
                RaisePropertyChanged("AllOrNone");
            }
        }

        private Money _lastTrade;
        public Money LastTrade
        {
            get { return _lastTrade; }
            set
            {
                _lastTrade = value;
                this.RaisePropertyChanged("LastTrade");
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