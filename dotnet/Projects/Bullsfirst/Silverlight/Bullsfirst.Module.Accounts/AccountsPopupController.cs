﻿/* Copyright 2011 Archfirst
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
using Bullsfirst.Module.Accounts.Views;
using Microsoft.Practices.Prism.Events;

namespace Bullsfirst.Module.Accounts
{
    [Export]
    [PartCreationPolicy(CreationPolicy.Shared)]
    public class AccountsPopupController
    {
        [ImportingConstructor]
        public AccountsPopupController(IEventAggregator eventAggregator)
        {
            eventAggregator.GetEvent<CreateAccountRequestEvent>().Subscribe(
                OnCreateAccountRequest, ThreadOption.UIThread, true);
            eventAggregator.GetEvent<EditAccountRequestEvent>().Subscribe(
                OnEditAccountRequest, ThreadOption.UIThread, true);
        }

        private void OnCreateAccountRequest(CreateAccountRequest request)
        {
            CreateNewAccountPopup popup = new CreateNewAccountPopup(request);
            popup.Show();         
        }

        private void OnEditAccountRequest(EditAccountRequest request)
        {
            EditAccountPopup popup = new EditAccountPopup(request);
            popup.Show();
        }
    }
}