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
using Bullsfirst.InterfaceOut.Oms.TradingServiceReference;

namespace Bullsfirst.InterfaceOut.Oms.Domain
{
    public class BaseAccountWrapper
    {
        public BaseAccountWrapper(BrokerageAccountSummary summary)
        {
            AccountSummary = summary;
            this.DisplayString = String.Format("{0} - {1} | {2}",
                summary.Name, summary.Id, summary.CashPosition.Amount.ToString("C"));
        }

        public BaseAccountWrapper(ExternalAccountSummary summary)
        {
            AccountSummary = summary;
            this.DisplayString = String.Format("{0} - {1} (External)",
                summary.Name, summary.AccountNumber);
        }

        public BaseAccountSummary AccountSummary { get; set; }
        public string DisplayString { get; set; }
    }
}