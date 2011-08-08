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
using System.Collections.Specialized;
using System.ComponentModel.Composition;
using System.Diagnostics;
using System.Windows.Controls;
using System.Windows.Data;
using Bullsfirst.InterfaceOut.Oms.TradingServiceReference;
using Bullsfirst.Module.Accounts.Interfaces;
using Archfirst.Framework.PrismHelpers;
using System.Windows.Controls.DataVisualization.Charting;

namespace Bullsfirst.Module.Accounts.Views
{
    [ViewExport(RegionName = "LoggedInUserRegion")]
    [PartCreationPolicy(CreationPolicy.NonShared)]
    public partial class AccountsView : UserControl
    {
        #region Construction

        /// <summary>
        /// Importing constructor is the easiest way to add the ViewModel as a resource.
        /// This is needed to fire commands from the DataGridTemplateColumn in the XAML
        /// file for this view. See http://compositewpf.codeplex.com/discussions/246631.
        /// </summary>
        [ImportingConstructor]
        public AccountsView(IAccountsViewModel viewModel)
        {
            Debug.WriteLine("[Debug] AccountsView.AccountsView()");
            this.DataContext = viewModel;
            this.Resources.Add("ViewModel", viewModel);
            InitializeComponent();

            // Detect changes to BrokerageAccountSummaries
            viewModel.getUserContext().BrokerageAccountSummaries.CollectionChanged +=
                new NotifyCollectionChangedEventHandler(BrokerageAccountSummariesChanged);

            ShowAccountsChart();
        }

        /// <summary>
        /// Detects changes to BrokerageAccountSummaries and reverts to AccountsChart
        /// </summary>
        private void BrokerageAccountSummariesChanged(object sender, NotifyCollectionChangedEventArgs e)
        {
            if (!_isShowingAccountsChart)
                ShowAccountsChart();
        }

        #endregion

        #region ShowAccountsChart

        private void ShowAccountsChart()
        {
             //Create the pie series associated with accounts
            PieSeries pieSeries = new PieSeries();
            pieSeries.ItemsSource = ((IAccountsViewModel)this.DataContext).getUserContext().BrokerageAccountSummaries;
            pieSeries.IndependentValueBinding = new Binding("Name");
            pieSeries.DependentValueBinding = new Binding("MarketValue.Amount");
            pieSeries.IsSelectionEnabled = true;
            pieSeries.SelectionChanged += new SelectionChangedEventHandler(AccountSelectionChanged);

            // Initialies the chart
            accountsChart.Title = "All Accounts";
            accountsChart.Series.Clear();
            accountsChart.Series.Add(pieSeries);
            _isShowingAccountsChart = true;
        }

        void AccountSelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            PieSeries series = (PieSeries)(accountsChart.Series[0]);
            BrokerageAccountSummary accountSummary = (BrokerageAccountSummary)(series.SelectedItem);
            ShowPositionsChart(accountSummary);
        }

        #endregion

        #region ShowPositionsChart

        void ShowPositionsChart(BrokerageAccountSummary accountSummary)
        {
            // Create the pie series associated with positions
            PieSeries pieSeries = new PieSeries();
            pieSeries.ItemsSource = accountSummary.Position;
            pieSeries.IndependentValueBinding = new Binding("InstrumentSymbol");
            pieSeries.DependentValueBinding = new Binding("MarketValue.Amount");
            pieSeries.IsSelectionEnabled = true;
            pieSeries.SelectionChanged += new SelectionChangedEventHandler(PositionSelectionChanged);

            // Initialies the chart
            accountsChart.Title = accountSummary.Name;
            accountsChart.Series.Clear();
            accountsChart.Series.Add(pieSeries);
            _isShowingAccountsChart = false;
        }

        void PositionSelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            ShowAccountsChart();
        }

        #endregion

        #region Members

        private bool _isShowingAccountsChart;

        #endregion
    }
}