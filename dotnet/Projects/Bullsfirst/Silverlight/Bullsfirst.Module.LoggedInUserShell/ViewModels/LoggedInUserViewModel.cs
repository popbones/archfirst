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
using System.ComponentModel.Composition;
using Archfirst.Framework.Helpers;
using Bullsfirst.Infrastructure;
using Bullsfirst.InterfaceOut.Oms.Security;
using Bullsfirst.Module.LoggedInUserShell.Interfaces;
using Microsoft.Practices.Prism.Commands;
using Microsoft.Practices.Prism.Events;
using Microsoft.Practices.Prism.Logging;
using Microsoft.Practices.Prism.Regions;
using Microsoft.Practices.Prism.ViewModel;

namespace Bullsfirst.Module.LoggedInUserShell.ViewModels
{
    [Export(typeof(ILoggedInUserViewModel))]
    [PartCreationPolicy(CreationPolicy.NonShared)]
    public class LoggedInUserViewModel : NotificationObject, ILoggedInUserViewModel
    {
        #region Construction

        [ImportingConstructor]
        public LoggedInUserViewModel(
            ILoggerFacade logger,
            IRegionManager regionManager,
            IEventAggregator eventAggregator,
            UserContext userContext)
        {
            logger.Log("LoggedInUserViewModel.LoggedInUserViewModel()", Category.Debug, Priority.Low);
            _logger = logger;
            _regionManager = regionManager;
            _eventAggregator = eventAggregator;
            this.UserContext = userContext;
            SignOutCommand = new DelegateCommand<object>(this.SignOutExecute);
            SubscribeToEvents();
        }

        private void SubscribeToEvents()
        {
            // Don't use strong reference to delegate
            _eventAggregator.GetEvent<UserLoggedInEvent>().Subscribe(OnUserLoggedIn, ThreadOption.UIThread);
            _eventAggregator.GetEvent<UserLoggedOutEvent>().Subscribe(OnUserLoggedOut, ThreadOption.UIThread);
        }

        #endregion

        #region SignOutCommand

        public DelegateCommand<object> SignOutCommand { get; set; }

        private void SignOutExecute(object dummyObject)
        {
            // Send UserLoggedOutEvent and switch to HomeView
            _eventAggregator.GetEvent<UserLoggedOutEvent>().Publish(Empty.Value);
            _regionManager.RequestNavigate(RegionNames.MainRegion, new Uri(ViewNames.HomeView, UriKind.Relative));
        }

        #endregion

        #region Event Handlers

        public void OnUserLoggedIn(Empty empty)
        {
        }

        public void OnUserLoggedOut(Empty empty)
        {
            this.UserContext.Reset();
        }

        #endregion

        #region Members

        private ILoggerFacade _logger;
        private IRegionManager _regionManager;
        private IEventAggregator _eventAggregator;

        public UserContext UserContext { get; set; }

        #endregion // Members
    }
}