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
using Microsoft.Practices.Prism.Commands;
using Microsoft.Practices.Prism.Logging;
using Microsoft.Practices.Prism.ViewModel;

namespace Bullsfirst.Infrastructure.Controls
{
    [Export(typeof(IStatusBar))]
    [PartCreationPolicy(CreationPolicy.Shared)]
    public class StatusBarViewModel : NotificationObject, IStatusBar
    {
        #region Construction

        public StatusBarViewModel()
        {
            ClearCommand = new DelegateCommand<object>(this.ClearCommandExecute);
        }

        #endregion

        #region IStatusBar Implementation

        public void ShowMessage(string message, Category category, Priority priority)
        {
            StatusMessage = string.Format("[{0}] {1}", category, message);
            Category = category;
        }

        public void Clear()
        {
            StatusMessage = null;
        }

        #endregion

        #region ClearCommand

        public DelegateCommand<object> ClearCommand { get; set; }

        private void ClearCommandExecute(object dummyObject)
        {
            this.Clear();
        }

        #endregion

        #region Members

        private string _statusMessage;
        public string StatusMessage
        {
            get { return _statusMessage; }
            set
            {
                _statusMessage = value;
                this.RaisePropertyChanged("StatusMessage");
            }
        }

        private Category _category;
        public Category Category
        {
            get { return _category; }
            set
            {
                _category = value;
                this.RaisePropertyChanged("Category");
            }
        }

        #endregion
    }
}