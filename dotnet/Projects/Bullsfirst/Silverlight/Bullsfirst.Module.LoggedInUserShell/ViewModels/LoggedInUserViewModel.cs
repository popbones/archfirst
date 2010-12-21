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
using System.ComponentModel.Composition;
using Bullsfirst.Infrastructure;
using Bullsfirst.InterfaceOut.Oms.Security;
using Bullsfirst.Module.LoggedInUserShell.Interfaces;
using Microsoft.Practices.Prism.Commands;
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
            UserContext userContext)
        {
            logger.Log("LoggedInUserViewModel.LoggedInUserViewModel()", Category.Debug, Priority.Low);
            _logger = logger;
            _regionManager = regionManager;
            this.UserContext = userContext;
            SignOutCommand = new DelegateCommand<object>(this.SignOutExecute);
        }

        #endregion

        #region SignOutCommand

        public DelegateCommand<object> SignOutCommand { get; set; }

        private void SignOutExecute(object dummyObject)
        {
            this.UserContext.Reset();
            _regionManager.RequestNavigate(RegionNames.MainRegion, new Uri(ViewNames.HomeView, UriKind.Relative));
        }

        #endregion

        #region Members

        private ILoggerFacade _logger;
        private IRegionManager _regionManager;

        public UserContext UserContext { get; set; }

        #endregion // Members
    }
}