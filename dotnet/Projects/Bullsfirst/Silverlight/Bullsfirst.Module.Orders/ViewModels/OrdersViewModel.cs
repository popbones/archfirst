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
            UserContext userContext)
        {
            logger.Log("PositionsViewModel.PositionsViewModel()", Category.Debug, Priority.Low);
            _logger = logger;
            _eventAggregator = eventAggregator;
            _tradingService = tradingService;
            this.UserContext = userContext;
            this.Orders = new ObservableCollection<Order>();

            this.UpdateOrdersCommand = new DelegateCommand<object>(this.UpdateOrdersExecute);
            this.CancelOrderCommand = new DelegateCommand<object>(this.CancelOrderExecute);

            _tradingService.GetOrdersCompleted +=
                new EventHandler<GetOrdersCompletedEventArgs>(GetOrdersCallback);
            _tradingService.CancelOrderCompleted +=
                new EventHandler<AsyncCompletedEventArgs>(CancelOrderCallback);

            SubscribeToEvents();
        }

        private void SubscribeToEvents()
        {
            // Don't use strong reference to delegate
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
            OrderCriteria criteria = new OrderCriteria
            {
                AccountIdSpecified = true,
                AccountId = this.UserContext.SelectedAccount.Id
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
                foreach (Order order in e.Result)
                {
                    Orders.Add(order);
                }
            }
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

        #region Event Handlers

        public void OnUserLoggedOut(Empty empty)
        {
            this.Orders.Clear();
        }

        #endregion

        #region Members

        private ILoggerFacade _logger;
        private IEventAggregator _eventAggregator;
        private ITradingServiceAsync _tradingService;
        public UserContext UserContext { get; set; }
        public ObservableCollection<Order> Orders { get; set; }

        public string ViewTitle
        {
            get { return "Orders"; }
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