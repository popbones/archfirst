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
using System.ComponentModel;
using System.ComponentModel.Composition;
using Archfirst.Framework.Helpers;
using Bullsfirst.Infrastructure;
using Bullsfirst.InterfaceOut.Oms.Domain;
using Bullsfirst.InterfaceOut.Oms.SecurityServiceReference;
using Bullsfirst.Module.Home.Interfaces;
using Microsoft.Practices.Prism.Commands;
using Microsoft.Practices.Prism.Events;
using Microsoft.Practices.Prism.Logging;
using Microsoft.Practices.Prism.Regions;
using Microsoft.Practices.Prism.ViewModel;

namespace Bullsfirst.Module.Home.ViewModels
{
    [Export(typeof(ILoginViewModel))]
    [PartCreationPolicy(CreationPolicy.NonShared)]
    public class LoginViewModel : NotificationObject, ILoginViewModel, IDataErrorInfo
    {
        #region Construction

        [ImportingConstructor]
        public LoginViewModel(
            ILoggerFacade logger,
            IRegionManager regionManager,
            IEventAggregator eventAggregator,
            ISecurityServiceAsync securityService,
            UserContext userContext)
        {
            logger.Log("LoginViewModel.LoginViewModel()", Category.Debug, Priority.Low);
            _logger = logger;
            _regionManager = regionManager;
            _eventAggregator = eventAggregator;
            _securityService = securityService;
            _securityService.AuthenticateUserCompleted += new EventHandler<AuthenticateUserCompletedEventArgs>(AuthenticateUserCallback);
            this.UserContext = userContext;
            LoginCommand = new DelegateCommand<object>(this.LoginExecute, this.CanLoginExecute);
            OpenAccountCommand = new DelegateCommand<object>(this.OpenAccountExecute);
            this.PropertyChanged += this.OnPropertyChanged;
            this.Validate();
        }

        private void OnPropertyChanged(object sender, PropertyChangedEventArgs e)
        {
            this.Validate();
            this.LoginCommand.RaiseCanExecuteChanged();
        }

        #endregion

        #region LoginCommand

        public DelegateCommand<object> LoginCommand { get; set; }

        private bool CanLoginExecute(object dummyObject)
        {
            return _errors.Count == 0;
        }

        private void LoginExecute(object dummyObject)
        {
            _securityService.AuthenticateUserAsync(Username, Password);
        }

        private void AuthenticateUserCallback(object sender, AuthenticateUserCompletedEventArgs e)
        {
            if (e.Error != null)
            {
                this.StatusMessage = e.Error.Message;
            }
            else if (e.Result.Success)
            {
                this.StatusMessage = null;
                this.UserContext.InitUser(e.Result.User);
                this.UserContext.InitCredentials(Username, Password);

                // Erase password from screen
                this.Password = null;

                // Send UserLoggedInEvent and switch to LoggedInUserView
                _eventAggregator.GetEvent<UserLoggedInEvent>().Publish(Empty.Value);
                _regionManager.RequestNavigate(
                    RegionNames.MainRegion,
                    new Uri(ViewNames.LoggedInUserView, UriKind.Relative));
            }
            else
            {
                this.StatusMessage = "Login failed";
            }
        }

        #endregion

        #region OpenAccountCommand

        public DelegateCommand<object> OpenAccountCommand { get; set; }

        private void OpenAccountExecute(object dummyObject)
        {
            _regionManager.RequestNavigate(
                RegionNames.MainRegion,
                new Uri(ViewNames.OpenAccountView, UriKind.Relative));
        }

        #endregion

        #region IDataErrorInfo implementation

        // Map column name to error string
        private readonly IDictionary<string, string> _errors = new Dictionary<string, string>();

        public string Error
        {
            get { throw new NotImplementedException(); }
        }

        public string this[string columnName]
        {
            get
            {
                if (_errors.ContainsKey(columnName))
                {
                    return _errors[columnName];
                }

                return null;
            }

            set
            {
                _errors[columnName] = value;
            }
        }

        // Validates all fields and updates _errors
        // This approach was necessary because OnPropertyChanged (and hence LoginCommand.RaiseCanExecuteChanged)
        // fires before this[string columnName] is fired by the IDataErrorInfo interface
        private void Validate()
        {
            if (string.IsNullOrEmpty(this.Username) || this.Username.Trim().Length == 0)
                this["Username"] = "Please enter your username";
            else
                this.ClearError("Username");

            if (string.IsNullOrEmpty(Password) || this.Password.Trim().Length == 0)
                this["Password"] = "Please enter your password";
            else
                this.ClearError("Password");
        }

        private void ClearError(string columnName)
        {
            if (_errors.ContainsKey(columnName))
            {
                _errors.Remove(columnName);
            }
        }

        #endregion

        #region Members

        private ILoggerFacade _logger;
        private IRegionManager _regionManager;
        private IEventAggregator _eventAggregator;
        private ISecurityServiceAsync _securityService;

        public UserContext UserContext { get; set; }

        private string _username;
        public string Username
        {
            get { return _username; }
            set
            {
                _username = value;
                this.RaisePropertyChanged("Username");
            }
        }

        private string _password;
        public string Password
        {
            get { return _password; }
            set
            {
                _password = value;
                this.RaisePropertyChanged("Password");
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

        #endregion // Members
    }
}