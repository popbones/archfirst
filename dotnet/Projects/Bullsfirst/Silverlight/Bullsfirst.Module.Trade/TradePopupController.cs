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
using System.ComponentModel.Composition;
using Bullsfirst.Module.Trade.Views;
using Microsoft.Practices.Prism.Events;

namespace Bullsfirst.Module.Trade
{
    [Export]
    [PartCreationPolicy(CreationPolicy.Shared)]
    public class TradePopupController
    {
        [ImportingConstructor]
        public TradePopupController(IEventAggregator eventAggregator)
        {
            eventAggregator.GetEvent<PreviewOrderRequestEvent>().Subscribe(
                OnPreviewOrderRequest, ThreadOption.UIThread, true);
        }

        private void OnPreviewOrderRequest(PreviewOrderRequest request)
        {
            PreviewOrderPopup popup = new PreviewOrderPopup(request);
            popup.Show();         
        }
    }
}