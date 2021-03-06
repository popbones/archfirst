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
using System;
using Microsoft.Practices.Prism.Events;

namespace Bullsfirst.Module.Accounts
{
    #region CreateAccountRequestEvent

    public class CreateAccountRequestEvent : CompositePresentationEvent<CreateAccountRequest>
    {
    }

    public class CreateAccountRequest
    {
        public Action<CreateAccountResponse> ResponseHandler { get; set; }
    }

    public class CreateAccountResponse
    {
        public bool Result { get; set; }
        public string AccountName { get; set; }
    }

    #endregion

    #region EditAccountRequestEvent

    public class EditAccountRequestEvent : CompositePresentationEvent<EditAccountRequest>
    {
    }

    public class EditAccountRequest
    {
        public long AccountId { get; set; }
        public string CurrentAccountName { get; set; }
        public Action<EditAccountResponse> ResponseHandler { get; set; }
    }

    public class EditAccountResponse
    {
        public bool Result { get; set; }
        public long AccountId { get; set; }
        public string NewAccountName { get; set; }
    }

    #endregion
}