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
using Bullsfirst.Infrastructure;
using Bullsfirst.InterfaceOut.Oms.Domain;
using Bullsfirst.InterfaceOut.Oms.TradingServiceReference;
using Bullsfirst.Module.Accounts.Interfaces;
using Microsoft.Practices.Prism.Commands;
using Microsoft.Practices.Prism.Events;
using Microsoft.Practices.Prism.Logging;
using Microsoft.Practices.Prism.Regions;
using Microsoft.Practices.Prism.ViewModel;

namespace Bullsfirst.Module.Accounts.ViewModels
{
    [Export(typeof(IAccountsViewModel))]
    [PartCreationPolicy(CreationPolicy.NonShared)]
    public class AccountsViewModel : NotificationObject, IAccountsViewModel
    {
        #region Construction

        [ImportingConstructor]
        public AccountsViewModel(
            ILoggerFacade logger,
            IRegionManager regionManager,
            IEventAggregator eventAggregator,
            ITradingServiceAsync tradingService,
            UserContext userContext)
        {
            logger.Log("AccountsViewModel.AccountsViewModel()", Category.Debug, Priority.Low);
            _logger = logger;
            _regionManager = regionManager;
            _eventAggregator = eventAggregator;
            _tradingService = tradingService;
            this.UserContext = userContext;

            _tradingService.OpenNewAccountCompleted += new EventHandler<OpenNewAccountCompletedEventArgs>(OpenNewAccountCallback);
            _tradingService.ChangeAccountNameCompleted += new EventHandler<AsyncCompletedEventArgs>(ChangeAccountNameCallback);
            CreateAccountCommand = new DelegateCommand<object>(this.CreateAccountExecute);
            EditAccountCommand = new DelegateCommand<object>(this.EditAccountExecute);
            UpdateAccountsCommand = new DelegateCommand<object>(this.UpdateAccountsExecute);
            SelectAccountCommand = new DelegateCommand<object>(this.SelectAccountExecute);
        }

        #endregion

        #region CreateAccountCommand

        public DelegateCommand<object> CreateAccountCommand { get; set; }

        private void CreateAccountExecute(object dummyObject)
        {
            // Send CreateAccountRequestEvent to create the CreateNewAccount dialog
            CreateAccountRequest request =
                new CreateAccountRequest { ResponseHandler = CreateAccountResponseHandler };
            _eventAggregator.GetEvent<CreateAccountRequestEvent>().Publish(request);
        }

        private void CreateAccountResponseHandler(CreateAccountResponse response)
        {
            if (response.Result == false) return;

            // Open the requested account
            _tradingService.OpenNewAccountAsync(response.AccountName);
        }

        private void OpenNewAccountCallback(object sender, OpenNewAccountCompletedEventArgs e)
        {
            if (e.Error != null)
            {
                this.StatusMessage = e.Error.Message;
            }
            else
            {
                this.StatusMessage = null;

                // Send AccountCreatedEvent
                _eventAggregator.GetEvent<AccountCreatedEvent>().Publish(Empty.Value);
            }
        }

        #endregion

        #region EditAccountCommand

        public DelegateCommand<object> EditAccountCommand { get; set; }

        private void EditAccountExecute(object dummyObject)
        {
            // Send EditAccountRequestEvent to create the EditAccount dialog
            EditAccountRequest request =
                new EditAccountRequest
                {
                    AccountId = ((BrokerageAccountSummary)dummyObject).Id,
                    CurrentAccountName = ((BrokerageAccountSummary)dummyObject).Name,
                    ResponseHandler = EditAccountResponseHandler
                };
            _eventAggregator.GetEvent<EditAccountRequestEvent>().Publish(request);
        }

        private void EditAccountResponseHandler(EditAccountResponse response)
        {
            if (response.Result == false) return;

            // Change name of the requested account
            _tradingService.ChangeAccountNameAsync(response.AccountId, response.NewAccountName);
        }

        private void ChangeAccountNameCallback(object sender, AsyncCompletedEventArgs e)
        {
            if (e.Error != null)
            {
                this.StatusMessage = e.Error.Message;
            }
            else
            {
                this.StatusMessage = null;

                // Send AccountUpdatedEvent
                _eventAggregator.GetEvent<AccountUpdatedEvent>().Publish(Empty.Value);
            }
        }

        #endregion

        #region UpdateAccountsCommand

        public DelegateCommand<object> UpdateAccountsCommand { get; set; }

        private void UpdateAccountsExecute(object dummyObject)
        {
            _eventAggregator.GetEvent<AllAccountsUpdateEvent>().Publish(Empty.Value);
        }

        #endregion

        #region SelectAccountCommand

        public DelegateCommand<object> SelectAccountCommand { get; set; }

        private void SelectAccountExecute(object dummyObject)
        {
            UserContext.SelectedAccount = (BrokerageAccountSummary)dummyObject;
            _regionManager.RequestNavigate(
                RegionNames.LoggedInUserRegion,
                new Uri(ViewNames.PositionsView, UriKind.Relative));
        }

        #endregion

        #region Members

        private ILoggerFacade _logger;
        private IRegionManager _regionManager;
        private IEventAggregator _eventAggregator;
        private ITradingServiceAsync _tradingService;
        public UserContext UserContext { get; set; }

        public string ViewTitle
        {
            get { return "Accounts"; }
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