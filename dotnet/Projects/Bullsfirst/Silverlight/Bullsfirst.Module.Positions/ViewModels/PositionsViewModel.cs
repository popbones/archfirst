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
using System.ComponentModel.Composition;
using Archfirst.Framework.Helpers;
using Bullsfirst.Infrastructure;
using Bullsfirst.InterfaceOut.Oms.Domain;
using Bullsfirst.InterfaceOut.Oms.TradingServiceReference;
using Bullsfirst.Module.Positions.Interfaces;
using Microsoft.Practices.Prism.Commands;
using Microsoft.Practices.Prism.Events;
using Microsoft.Practices.Prism.Logging;
using Microsoft.Practices.Prism.Regions;
using Microsoft.Practices.Prism.ViewModel;

namespace Bullsfirst.Module.Positions.ViewModels
{
    [Export(typeof(IPositionsViewModel))]
    [PartCreationPolicy(CreationPolicy.NonShared)]
    public class PositionsViewModel : NotificationObject, IPositionsViewModel
    {
        #region Construction

        [ImportingConstructor]
        public PositionsViewModel(
            ILoggerFacade logger,
            IRegionManager regionManager,
            IEventAggregator eventAggregator,
            UserContext userContext)
        {
            logger.Log("PositionsViewModel.PositionsViewModel()", Category.Debug, Priority.Low);
            _logger = logger;
            _regionManager = regionManager;
            _eventAggregator = eventAggregator;
            this.UserContext = userContext;

            BuyCommand = new DelegateCommand<object>(this.CreateBuyOrderExecute);
            SellCommand = new DelegateCommand<object>(this.CreateSellOrderExecute);
            UpdateAccountsCommand = new DelegateCommand<object>(this.UpdateAccountsExecute);
        }

        #endregion

        #region BuyCommand and SellCommand

        public DelegateCommand<object> BuyCommand { get; set; }
        public DelegateCommand<object> SellCommand { get; set; }

        private void CreateBuyOrderExecute(object dummyObject)
        {
            CreateOrderExecute(dummyObject, OrderSide.Buy);
        }

        private void CreateSellOrderExecute(object dummyObject)
        {
            CreateOrderExecute(dummyObject, OrderSide.Sell);
        }

        private void CreateOrderExecute(object dummyObject, OrderSide side)
        {
            // Send PopulateOrderEvent and switch to trade page
            Position position = (Position)dummyObject;
            _eventAggregator.GetEvent<PopulateOrderEvent>().Publish(
                new PopulateOrderEventArgs
                {
                    Symbol = position.InstrumentSymbol,
                    Side = side,
                    Quantity = position.Quantity
                });
            _regionManager.RequestNavigate(
                RegionNames.LoggedInUserRegion,
                new Uri(ViewNames.TradeView, UriKind.Relative));
        }

        #endregion

        #region UpdateAccountsCommand

        public DelegateCommand<object> UpdateAccountsCommand { get; set; }

        private void UpdateAccountsExecute(object dummyObject)
        {
            _eventAggregator.GetEvent<AllAccountsUpdateEvent>().Publish(Empty.Value);
        }

        #endregion

        #region Members

        private ILoggerFacade _logger;
        private IRegionManager _regionManager;
        private IEventAggregator _eventAggregator;
        public UserContext UserContext { get; set; }
        
        public string ViewTitle
        {
            get { return "Positions"; }
        }

        #endregion
    }
}