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
using System.Diagnostics;
using System.Windows.Controls;

namespace DataValidationSample
{
    public partial class SampleView : UserControl
    {
        public SampleView()
        {
            InitializeComponent();
            DataContext = new SampleViewModel();
        }

        private void age_BindingValidationError(object sender, ValidationErrorEventArgs e)
        {
            Debug.WriteLine("[Debug] age_BindingValidationError: Action=" + e.Action + ", Error=" + e.Error.ErrorContent);
        }
    }
}