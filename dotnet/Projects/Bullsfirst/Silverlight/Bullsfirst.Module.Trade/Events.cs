/* Copyright 2011 Archfirst
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
using Bullsfirst.Module.Trade.ViewModels;
using Microsoft.Practices.Prism.Events;

namespace Bullsfirst.Module.Trade
{
    #region CreateAccountRequestEvent

    public class PreviewOrderRequestEvent : CompositePresentationEvent<PreviewOrderRequest>
    {
    }

    public class PreviewOrderRequest
    {
        public string Symbol { get; set; }
        public Action<PreviewOrderResponse> ResponseHandler { get; set; }
    }

    public class PreviewOrderResponse
    {
        public bool Result { get; set; }
    }

    #endregion
}