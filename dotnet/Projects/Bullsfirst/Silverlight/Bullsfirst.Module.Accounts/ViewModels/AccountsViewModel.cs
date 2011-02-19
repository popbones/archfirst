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
using Bullsfirst.InterfaceOut.Oms.Domain;
using Bullsfirst.Module.Accounts.Interfaces;
using Microsoft.Practices.Prism.Commands;
using Microsoft.Practices.Prism.Logging;
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
            UserContext userContext)
        {
            logger.Log("AccountsViewModel.AccountsViewModel()", Category.Debug, Priority.Low);
            _logger = logger;
            this.UserContext = userContext;
            CreateAccountCommand = new DelegateCommand<object>(this.CreateAccountExecute);
            EditAccountCommand = new DelegateCommand<object>(this.EditAccountExecute);
            SelectAccountCommand = new DelegateCommand<object>(this.SelectAccountExecute);
        }

        #endregion

        #region CreateAccountCommand

        public DelegateCommand<object> CreateAccountCommand { get; set; }

        private void CreateAccountExecute(object dummyObject)
        {
            // Debug.WriteLine("---------> Create Account");
        }

        #endregion

        #region EditAccountCommand

        public DelegateCommand<object> EditAccountCommand { get; set; }

        private void EditAccountExecute(object dummyObject)
        {
            // Debug.WriteLine("---------> Edit Account: " + ((AccountSummary)dummyObject).Name);
        }

        #endregion

        #region SelectAccountCommand

        public DelegateCommand<object> SelectAccountCommand { get; set; }

        private void SelectAccountExecute(object dummyObject)
        {
            // Debug.WriteLine("---------> " + ((AccountSummary)dummyObject).Name);
        }

        #endregion

        #region Members

        private ILoggerFacade _logger;
        public UserContext UserContext { get; set; }

        public string ViewTitle
        {
            get { return "Accounts"; }
        }

        #endregion
    }
}