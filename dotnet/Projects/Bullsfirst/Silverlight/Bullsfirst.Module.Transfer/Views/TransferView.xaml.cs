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
using Bullsfirst.InterfaceOut.Oms.ReferenceDataServiceReference;
using Bullsfirst.Module.Transfer.Interfaces;

namespace Bullsfirst.Module.Transfer.Views
{
    [ViewExport(RegionName = "LoggedInUserRegion")]
    [PartCreationPolicy(CreationPolicy.NonShared)]
    public partial class TransferView : UserControl
    {
        public TransferView()
        {
            Debug.WriteLine("[Debug] TransferView.TransferView()");
            InitializeComponent();
            symbolField.ItemFilter += InstrumentFilter;
        }

        [Import]
        public ITransferViewModel ViewModel
        {
            get { return (ITransferViewModel)this.DataContext; }
            set { this.DataContext = value; }
        }

        /// <summary>
        /// Predicate used for filtering instruments for a given search string
        /// </summary>
        /// <param name="search">The string used for filtering</param>
        /// <param name="value">The instrument that is being compared with the search parameter</param>
        /// <returns></returns>
        bool InstrumentFilter(string search, object value)
        {
            Instrument instrument = value as Instrument;
            if (instrument != null)
            {
                search = search.ToUpper();
                return (instrument.Symbol.ToUpper().Contains(search) ||
                        instrument.Name.ToUpper().Contains(search));
            }
            else
            {
                return false;
            }
        }

        private void symbolField_LostFocus(object sender, System.Windows.RoutedEventArgs e)
        {
            ViewModel.UpdateLastTrade();
        }
    }
}