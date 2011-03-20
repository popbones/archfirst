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
using System.Windows.Controls;
using Bullsfirst.InterfaceOut.Oms.TradingServiceReference;
using Microsoft.Practices.Prism.Commands;

namespace Bullsfirst.Module.Trade.Views
{
    public partial class PreviewOrderPopup : ChildWindow
    {
        #region Construction

        public PreviewOrderPopup(PreviewOrderRequest request)
        {
            InitializeComponent();
            this.OrderParams = request.OrderParams;
            this.OrderEstimate = request.OrderEstimate;
            this.ResponseHandler = request.ResponseHandler;
            this.DataContext = this;

            PlaceOrderCommand = new DelegateCommand<object>(this.PlaceOrderExecute);
            EditOrderCommand = new DelegateCommand<object>(this.EditOrderExecute);
        }

        #endregion

        #region PlaceOrderCommand

        public DelegateCommand<object> PlaceOrderCommand { get; set; }

        private void PlaceOrderExecute(object dummyObject)
        {
            this.DialogResult = true;
            ResponseHandler(new PreviewOrderResponse { Result = true });
        }

        #endregion

        #region EditOrderCommand

        public DelegateCommand<object> EditOrderCommand { get; set; }

        private void EditOrderExecute(object dummyObject)
        {
            this.DialogResult = false;
            ResponseHandler(new PreviewOrderResponse { Result = false });
        }

        #endregion

        #region Members

        public OrderParams OrderParams { get; set; }
        public OrderEstimate OrderEstimate { get; set; }
        public Action<PreviewOrderResponse> ResponseHandler { get; set; }

        #endregion
    }
}