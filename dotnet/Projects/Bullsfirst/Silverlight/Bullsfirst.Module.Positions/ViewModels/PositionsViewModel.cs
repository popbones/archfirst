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
using System.ComponentModel.Composition;
using System.Diagnostics;
using Bullsfirst.InterfaceOut.Oms.Domain;
using Bullsfirst.InterfaceOut.Oms.TradingServiceReference;
using Bullsfirst.Module.Positions.Interfaces;
using Microsoft.Practices.Prism.Commands;
using Microsoft.Practices.Prism.Logging;
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
            UserContext userContext)
        {
            logger.Log("PositionsViewModel.PositionsViewModel()", Category.Debug, Priority.Low);
            _logger = logger;
            this.UserContext = userContext;

            BuyCommand = new DelegateCommand<object>(this.CreateBuyOrderExecute);
            SellCommand = new DelegateCommand<object>(this.CreateSellOrderExecute);
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
            Position position = (Position)dummyObject;
            Debug.WriteLine(side + " " + position.Quantity + " of " + position.InstrumentSymbol);
        }

        #endregion

        #region Members

        private ILoggerFacade _logger;
        public UserContext UserContext { get; set; }
        
        public string ViewTitle
        {
            get { return "Positions"; }
        }

        #endregion
    }
}