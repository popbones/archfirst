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
using System.ComponentModel;
using System.ComponentModel.Composition;
using Archfirst.Framework.Helpers;
using Archfirst.Framework.PrismHelpers;
using Bullsfirst.Infrastructure;
using Bullsfirst.Infrastructure.Controls;
using Bullsfirst.InterfaceOut.Oms.Domain;
using Bullsfirst.InterfaceOut.Oms.SecurityServiceReference;
using Bullsfirst.Module.Home.Interfaces;
using Microsoft.Practices.Prism.Commands;
using Microsoft.Practices.Prism.Events;
using Microsoft.Practices.Prism.Logging;
using Microsoft.Practices.Prism.Regions;

namespace Bullsfirst.Module.Home.ViewModels
{
    [Export(typeof(ILoginViewModel))]
    [PartCreationPolicy(CreationPolicy.NonShared)]
    public class LoginViewModel : BaseDataValidator, ILoginViewModel
    {
        #region Construction

        [ImportingConstructor]
        public LoginViewModel(
            ILoggerFacade logger,
            IStatusBar statusBar,
            IRegionManager regionManager,
            IEventAggregator eventAggregator,
            ISecurityServiceAsync securityService,
            UserContext userContext)
        {
            logger.Log("LoginViewModel.LoginViewModel()", Category.Debug, Priority.Low);
            _logger = logger;
            _statusBar = statusBar;
            _regionManager = regionManager;
            _eventAggregator = eventAggregator;
            _securityService = securityService;
            _securityService.AuthenticateUserCompleted += new EventHandler<AuthenticateUserCompletedEventArgs>(AuthenticateUserCallback);
            this.UserContext = userContext;
            LoginCommand = new DelegateCommand<object>(this.LoginExecute, this.CanLoginExecute);
            OpenAccountCommand = new DelegateCommand<object>(this.OpenAccountExecute);
#if !SILVERLIGHT
            PasswordChangedCommand = new DelegateCommand<object>(this.PasswordChangedExecute);
#endif
            this.PropertyChanged += this.OnPropertyChanged;
            this.ValidateAll();
        }

        private void OnPropertyChanged(object sender, PropertyChangedEventArgs e)
        {
            this.Validate(e.PropertyName);
            this.LoginCommand.RaiseCanExecuteChanged();
        }

        #endregion

        #region LoginCommand

        public DelegateCommand<object> LoginCommand { get; set; }

        private bool CanLoginExecute(object dummyObject)
        {
            return this.CanCommandExecute();
        }

        private void LoginExecute(object dummyObject)
        {
            _securityService.AuthenticateUserAsync(Username, Password);
        }

#if !SILVERLIGHT
        public DelegateCommand<object> PasswordChangedCommand { get; set; }

        private void PasswordChangedExecute (object parameter)
        {
            this.Password = (string)parameter;
        }
#endif

        private void AuthenticateUserCallback(object sender, AuthenticateUserCompletedEventArgs e)
        {
            if (e.Error != null)
            {
                _statusBar.ShowMessage(e.Error.Message, Category.Exception, Priority.High);
            }
            else if (e.Result.Success)
            {
                _statusBar.Clear();
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
                _statusBar.ShowMessage("Login failed", Category.Exception, Priority.High);
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

        private void ValidateAll()
        {
            this.Validate("Username");
            this.Validate("Password");
        }

        private void Validate(string propertyName)
        {
            switch (propertyName)
            {
                case "Username":
                    if (string.IsNullOrEmpty(this.Username) || this.Username.Trim().Length == 0)
                        this["Username"] = "Please enter your username";
                    else
                        this.ClearError("Username");
                    break;

                case "Password":
                    if (string.IsNullOrEmpty(Password) || this.Password.Trim().Length == 0)
                        this["Password"] = "Please enter your password";
                    else
                        this.ClearError("Password");
                    break;
            }
        }

        #endregion

        #region Members

        private ILoggerFacade _logger;
        private IStatusBar _statusBar;
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
        
        #endregion // Members
    }
}