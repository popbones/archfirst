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
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;

namespace DataValidationSample
{
    public abstract class BaseDataValidator : IDataErrorInfo, INotifyPropertyChanged
    {
        #region INotifyPropertyChanged

        public event PropertyChangedEventHandler PropertyChanged;

        protected void RaisePropertyChanged(string propertyName)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
            }
        }

        #endregion

        #region IDataErrorInfo implementation

        public string Error
        {
            get { throw new NotImplementedException(); }
        }

        // Map column name to error string
        private readonly IDictionary<string, string> _errors =
            new Dictionary<string, string>();

        public string this[string columnName]
        {
            get
            {
                if (_errors.ContainsKey(columnName))
                {
                    return _errors[columnName];
                }

                return null;
            }

            set
            {
                _errors[columnName] = value;
            }
        }

        protected void ClearError(string columnName)
        {
            if (_errors.ContainsKey(columnName))
            {
                _errors.Remove(columnName);
            }
        }

        protected bool CanCommandExecute()
        {
            Debug.WriteLine("[Debug] CanCommandExecute: error count = " + _errors.Count);
            return _errors.Count == 0;
        }

        #endregion
    }
}