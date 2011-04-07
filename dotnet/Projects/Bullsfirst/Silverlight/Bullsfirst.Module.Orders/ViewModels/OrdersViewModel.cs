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
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.ComponentModel.Composition;
using Archfirst.Framework.Helpers;
using Bullsfirst.Infrastructure;
using Bullsfirst.InterfaceOut.Oms.Domain;
using Bullsfirst.InterfaceOut.Oms.TradingServiceReference;
using Bullsfirst.Module.Orders.Interfaces;
using Microsoft.Practices.Prism.Commands;
using Microsoft.Practices.Prism.Events;
using Microsoft.Practices.Prism.Logging;
using Microsoft.Practices.Prism.ViewModel;

namespace Bullsfirst.Module.Orders.ViewModels
{
    [Export(typeof(IOrdersViewModel))]
    [PartCreationPolicy(CreationPolicy.NonShared)]
    public class OrdersViewModel : NotificationObject, IOrdersViewModel
    {
        #region Construction

        [ImportingConstructor]
        public OrdersViewModel(
            ILoggerFacade logger,
            IEventAggregator eventAggregator,
            ITradingServiceAsync tradingService,
            UserContext userContext,
            ReferenceData referenceData)
        {
            logger.Log("PositionsViewModel.PositionsViewModel()", Category.Debug, Priority.Low);
            _logger = logger;
            _eventAggregator = eventAggregator;
            _tradingService = tradingService;
            this.UserContext = userContext;
            this.Orders = new ObservableCollection<Order>();
            this.ReferenceData = referenceData;

            this.UpdateOrdersCommand = new DelegateCommand<object>(this.UpdateOrdersExecute);
            this.ResetFilterCommand = new DelegateCommand<object>(this.ResetFilterExecute);
            this.CancelOrderCommand = new DelegateCommand<object>(this.CancelOrderExecute);

            _tradingService.GetOrdersCompleted +=
                new EventHandler<GetOrdersCompletedEventArgs>(GetOrdersCallback);
            _tradingService.CancelOrderCompleted +=
                new EventHandler<AsyncCompletedEventArgs>(CancelOrderCallback);
            this.UserContext.PropertyChanged +=
                new PropertyChangedEventHandler(OnUserContextPropertyChanged);

            ResetFilter();
            SubscribeToEvents();
        }

        private void SubscribeToEvents()
        {
            // Don't use strong reference to delegate
            _eventAggregator.GetEvent<OrderPlacedEvent>().Subscribe(OnOrderPlaced, ThreadOption.UIThread, true);
            _eventAggregator.GetEvent<UserLoggedOutEvent>().Subscribe(OnUserLoggedOut, ThreadOption.UIThread, true);
        }

        #endregion

        #region UpdateOrdersCommand

        public DelegateCommand<object> UpdateOrdersCommand { get; set; }

        private void UpdateOrdersExecute(object dummyObject)
        {
            UpdateOrders();
        }

        private void UpdateOrders()
        {
            // Protect against SelectedAccount being null
            if (this.UserContext.SelectedAccount == null)
                return;

            OrderCriteria criteria = new OrderCriteria
            {
                AccountIdSpecified = true,
                AccountId = this.UserContext.SelectedAccount.Id,

                OrderIdSpecified = OrderId.HasValue,
                OrderId = OrderId.HasValue ? OrderId.Value : 0,

                Symbol = (string.IsNullOrEmpty(Symbol) || Symbol.Trim().Length == 0) ? null : Symbol,

                FromDateSpecified = FromDate.HasValue,
                FromDate = FromDate.HasValue ? FromDate.Value : DateTime.MinValue,

                ToDateSpecified = ToDate.HasValue,
                ToDate = ToDate.HasValue ? ToDate.Value : DateTime.MinValue,

                Side = GetSideFilters(),
                Status = GetStatusFilters()
            };
            _tradingService.GetOrdersAsync(criteria);
        }

        private void GetOrdersCallback(object sender, GetOrdersCompletedEventArgs e)
        {
            if (e.Error != null)
            {
                this.StatusMessage = e.Error.Message;
            }
            else
            {
                this.StatusMessage = null;
                Orders.Clear();
                if (e.Result != null) // in case there are no orders
                {
                    foreach (Order order in e.Result)
                    {
                        Orders.Add(order);
                    }
                }
            }
        }

        private OrderSide[] GetSideFilters()
        {
            // Create a list of checked filters
            List<OrderSide> sides = new List<OrderSide>();
            if (ActionBuy) sides.Add(OrderSide.Buy);
            if (ActionSell) sides.Add(OrderSide.Sell);

            // Convert list to array
            return (sides.Count > 0) ? sides.ToArray() : null;
        }

        private OrderStatus[] GetStatusFilters()
        {
            // Create a list of checked statuses
            List<OrderStatus> statuses = new List<OrderStatus>();
            if (StatusNew) statuses.Add(OrderStatus.New);
            if (StatusPartiallyFilled) statuses.Add(OrderStatus.PartiallyFilled);
            if (StatusFilled) statuses.Add(OrderStatus.Filled);
            if (StatusCanceled) statuses.Add(OrderStatus.Canceled);
            if (StatusDoneForDay) statuses.Add(OrderStatus.DoneForDay);

            // Convert list to array
            return (statuses.Count > 0) ? statuses.ToArray() : null;
        }

        #endregion

        #region CancelOrderCommand

        public DelegateCommand<object> CancelOrderCommand { get; set; }

        private void CancelOrderExecute(object dummyObject)
        {
            Order order = (Order)dummyObject;
            _tradingService.CancelOrderAsync(order.Id);
        }

        private void CancelOrderCallback(object sender, AsyncCompletedEventArgs e)
        {
            if (e.Error != null)
            {
                this.StatusMessage = e.Error.Message;
            }
            else
            {
                this.StatusMessage = null;
                this.UpdateOrders();
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
            OrderId = null;
            Symbol = null;
            FromDate = DateTime.Now;
            ToDate = DateTime.Now;

            ActionBuy = false;
            ActionSell = false;

            StatusNew = false;
            StatusPartiallyFilled = false;
            StatusFilled = false;
            StatusCanceled = false;
            StatusDoneForDay = false;

            Orders.Clear();
        }

        #endregion

        #region Event Handlers

        public void OnOrderPlaced(Empty empty)
        {
            this.UpdateOrders();
        }

        public void OnUserLoggedOut(Empty empty)
        {
            this.ResetFilter();
        }

        public void OnUserContextPropertyChanged(Object sender, PropertyChangedEventArgs e)
        {
            // If selected account has changed then update orders based on new account
            if (e.PropertyName.Equals("SelectedAccount"))
                this.UpdateOrders();
        }

        #endregion

        #region Members

        private ILoggerFacade _logger;
        private IEventAggregator _eventAggregator;
        private ITradingServiceAsync _tradingService;
        public UserContext UserContext { get; set; }
        public ReferenceData ReferenceData { get; set; }
        public ObservableCollection<Order> Orders { get; set; }

        public string ViewTitle
        {
            get { return "Orders"; }
        }

        private Nullable<long> _orderId;
        public Nullable<long> OrderId
        {
            get { return _orderId; }
            set
            {
                _orderId = value;
                RaisePropertyChanged("OrderId");
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

        private bool _actionBuy;
        public bool ActionBuy
        {
            get { return _actionBuy; }
            set
            {
                _actionBuy = value;
                RaisePropertyChanged("ActionBuy");
            }
        }

        private bool _actionSell;
        public bool ActionSell
        {
            get { return _actionSell; }
            set
            {
                _actionSell = value;
                RaisePropertyChanged("ActionSell");
            }
        }

        private bool _statusNew;
        public bool StatusNew
        {
            get { return _statusNew; }
            set
            {
                _statusNew = value;
                RaisePropertyChanged("StatusNew");
            }
        }

        private bool _statusPartiallyFilled;
        public bool StatusPartiallyFilled
        {
            get { return _statusPartiallyFilled; }
            set
            {
                _statusPartiallyFilled = value;
                RaisePropertyChanged("StatusPartiallyFilled");
            }
        }

        private bool _statusFilled;
        public bool StatusFilled
        {
            get { return _statusFilled; }
            set
            {
                _statusFilled = value;
                RaisePropertyChanged("StatusFilled");
            }
        }

        private bool _statusCanceled;
        public bool StatusCanceled
        {
            get { return _statusCanceled; }
            set
            {
                _statusCanceled = value;
                RaisePropertyChanged("StatusCanceled");
            }
        }

        private bool _statusDoneForDay;
        public bool StatusDoneForDay
        {
            get { return _statusDoneForDay; }
            set
            {
                _statusDoneForDay = value;
                RaisePropertyChanged("StatusDoneForDay");
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