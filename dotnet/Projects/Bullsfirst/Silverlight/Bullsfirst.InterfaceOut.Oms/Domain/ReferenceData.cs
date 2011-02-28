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
using System.Collections.ObjectModel;
using System.ComponentModel.Composition;
using System.Diagnostics;
using Bullsfirst.InterfaceOut.Oms.ReferenceDataServiceReference;

namespace Bullsfirst.InterfaceOut.Oms.Domain
{
    [Export]
    [PartCreationPolicy(CreationPolicy.Shared)]
    public class ReferenceData
    {
        [ImportingConstructor]
        public ReferenceData(IReferenceDataServiceAsync referenceDataService)
        {
            _referenceDataService = referenceDataService;
            Instruments = new ObservableCollection<Instrument>();

            _referenceDataService.GetInstrumentsCompleted +=
                new EventHandler<GetInstrumentsCompletedEventArgs>(GetInstrumentsCallback);
        }

        public void Initialize()
        {
            if (_isInitialized) return;
            _isInitialized = true;
            _referenceDataService.GetInstrumentsAsync();
        }

        public void GetInstrumentsCallback(object sender, GetInstrumentsCompletedEventArgs e)
        {
            Debug.WriteLine("[Debug] [{0}] ---> ReferenceData.GetInstrumentsCallback()", DateTime.Now);
            if (e.Error == null)
            {
                // Initialize instruments
                foreach (Instrument instrument in e.Result)
                {
                    Instruments.Add(instrument);
                }
            }
            Debug.WriteLine("[Debug] [{0}] <--- ReferenceData.GetInstrumentsCallback()", DateTime.Now);
        }

        private bool _isInitialized = false;
        private IReferenceDataServiceAsync _referenceDataService;
        public ObservableCollection<Instrument> Instruments { get; set; }
    }
}