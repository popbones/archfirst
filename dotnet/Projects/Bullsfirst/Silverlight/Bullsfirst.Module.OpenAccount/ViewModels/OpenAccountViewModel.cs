﻿/* Copyright 2010 Archfirst
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
using Bullsfirst.InterfaceOut.Oms.Security;
using Bullsfirst.InterfaceOut.Oms.SecurityServiceReference;
using Bullsfirst.Module.OpenAccount.Interfaces;
using Microsoft.Practices.Prism.Commands;
using Microsoft.Practices.Prism.Events;
using Microsoft.Practices.Prism.Logging;
using Microsoft.Practices.Prism.Regions;
using Microsoft.Practices.Prism.ViewModel;

namespace Bullsfirst.Module.OpenAccount.ViewModels
{
    [Export(typeof(IOpenAccountViewModel))]
    [PartCreationPolicy(CreationPolicy.NonShared)]
    public class OpenAccountViewModel : NotificationObject, IOpenAccountViewModel, IDataErrorInfo
    {
        #region Construction

        [ImportingConstructor]
        public OpenAccountViewModel(
            ILoggerFacade logger,
            IRegionManager regionManager,
            IEventAggregator eventAggregator,
            ISecurityServiceAsync securityService,
            //ITradingServiceAsync tradingService,
            UserContext userContext)
        {
            logger.Log("OpenAccountViewModel.OpenAccountViewModel()", Category.Debug, Priority.Low);
            _logger = logger;
            _regionManager = regionManager;
            _eventAggregator = eventAggregator;
            _securityService = securityService;
            //_tradingService = tradingService;
            _securityService.RegisterUserCompleted += new EventHandler<AsyncCompletedEventArgs>(RegisterUserCallback);
            this.UserContext = userContext;
            OpenAccountCommand = new DelegateCommand<object>(this.OpenAccountExecute, this.CanOpenAccountExecute);
            CancelCommand = new DelegateCommand<object>(this.CancelExecute);
            this.PropertyChanged += this.OnPropertyChanged;
            this.Validate();
        }

        private void OnPropertyChanged(object sender, PropertyChangedEventArgs e)
        {
            this.Validate();
            this.OpenAccountCommand.RaiseCanExecuteChanged();
        }

        #endregion

        #region OpenAccountCommand

        public DelegateCommand<object> OpenAccountCommand { get; set; }

        private bool CanOpenAccountExecute(object dummyObject)
        {
            return _errors.Count == 0;
        }

        private void OpenAccountExecute(object dummyObject)
        {
            registrationRequest registrationRequest = new registrationRequest()
            {
                FirstName = FirstName,
                LastName = LastName,
                Username = Username,
                Password = Password
            };
            _securityService.RegisterUserAsync(registrationRequest);
        }

        private void RegisterUserCallback(object sender, AsyncCompletedEventArgs e)
        {
            if (e.Error != null)
            {
                this.StatusMessage = e.Error.Message;
            }
            else
            {
                this.StatusMessage = null;
                this.UserContext.InitUser(Username, FirstName, LastName);
                this.UserContext.InitCredentials(Username, Password);

                this.ClearForm();

                // Send UserLoggedInEvent and switch to LoggedInUserView
                _eventAggregator.GetEvent<UserLoggedInEvent>().Publish(Empty.Value);
                _regionManager.RequestNavigate(RegionNames.MainRegion, new Uri(ViewNames.LoggedInUserView, UriKind.Relative));
            }
        }

        #endregion

        #region CancelCommand

        public DelegateCommand<object> CancelCommand { get; set; }

        private void CancelExecute(object dummyObject)
        {
            this.ClearForm();
            _regionManager.RequestNavigate(RegionNames.MainRegion, new Uri(ViewNames.HomeView, UriKind.Relative));
        }

        #endregion

        #region Helpers

        private void ClearForm()
        {
            this.FirstName = null;
            this.LastName = null;
            this.Username = null;
            this.Password = null;
            this.ConfirmPassword = null;
            this.StatusMessage = null;
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
            if (string.IsNullOrEmpty(this.FirstName) || this.FirstName.Trim().Length == 0)
                this["FirstName"] = "Please enter your first name";
            else
                this.ClearError("FirstName");

            if (string.IsNullOrEmpty(this.LastName) || this.LastName.Trim().Length == 0)
                this["LastName"] = "Please enter your last name";
            else
                this.ClearError("LastName");

            if (string.IsNullOrEmpty(this.Username) || this.Username.Trim().Length == 0)
                this["Username"] = "Please enter your username";
            else
                this.ClearError("Username");

            if (string.IsNullOrEmpty(Password) || this.Password.Trim().Length == 0)
                this["Password"] = "Please enter your password";
            else
                this.ClearError("Password");

            if (string.IsNullOrEmpty(ConfirmPassword) || this.ConfirmPassword.Trim().Length == 0)
                this["ConfirmPassword"] = "Please confirm your password";
            else if (!ConfirmPassword.Equals(Password))
                this["ConfirmPassword"] = "Passwords don't match";
            else
                this.ClearError("ConfirmPassword");
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
        //private ITradingServiceAsync _tradingService;

        public UserContext UserContext { get; set; }

        private string _firstName;
        public string FirstName
        {
            get { return _firstName; }
            set
            {
                _firstName = value;
                this.RaisePropertyChanged("FirstName");
            }
        }

        private string _lastName;
        public string LastName
        {
            get { return _lastName; }
            set
            {
                _lastName = value;
                this.RaisePropertyChanged("LastName");
            }
        }

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

        private string _confirmPassword;
        public string ConfirmPassword
        {
            get { return _confirmPassword; }
            set
            {
                _confirmPassword = value;
                this.RaisePropertyChanged("ConfirmPassword");
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