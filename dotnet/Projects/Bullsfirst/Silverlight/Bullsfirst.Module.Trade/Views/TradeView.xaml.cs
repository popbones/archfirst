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
using System.Windows.Controls;
using Archfirst.Framework.PrismHelpers;
using Bullsfirst.Module.Trade.Interfaces;

namespace Bullsfirst.Module.Trade.Views
{
    [ViewExport(RegionName = "LoggedInUserRegion")]
    [PartCreationPolicy(CreationPolicy.NonShared)]
    public partial class TradeView : UserControl
    {
        public TradeView()
        {
            Debug.WriteLine("[Debug] TradeView.TradeView()");
            InitializeComponent();
        }

        [Import]
        public ITradeViewModel ViewModel
        {
            set { this.DataContext = value; }
        }
    }
}