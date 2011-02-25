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
using Microsoft.Practices.Prism.Commands;
using Microsoft.Practices.Prism.ViewModel;

namespace DataValidationSample
{
    public class SampleViewModel : NotificationObject, IDataErrorInfo
    {
        #region Construction

        public SampleViewModel()
        {
            SubmitCommand = new DelegateCommand<object>(this.SubmitExecute, this.CanSubmitExecute);
            this.PropertyChanged += this.OnPropertyChanged;
            this.ValidateAll();
        }

        private void OnPropertyChanged(object sender, PropertyChangedEventArgs e)
        {
            Debug.WriteLine("[Debug] OnPropertyChanged: " + e.PropertyName);
            this.Validate(e.PropertyName);
            this.SubmitCommand.RaiseCanExecuteChanged();
        }

        #endregion

        #region SubmitCommand

        public DelegateCommand<object> SubmitCommand { get; set; }

        private bool CanSubmitExecute(object dummyObject)
        {
            Debug.WriteLine("[Debug] CanSubmitExecute: error count = " + _errors.Count);
            return _errors.Count == 0;
        }

        private void SubmitExecute(object dummyObject)
        {
            this.StatusMessage = "Name: " + this.Name + ", Age: " + this.Age;
        }

        #endregion

        #region IDataErrorInfo implementation

        // Map column name to error string
        private readonly IDictionary<string, string> _errors = new Dictionary<string, string>();

        public string Error
        {
            get { throw new NotImplementedException(); }
        }

        public string this[string columnName]
        {
            get
            {
                if (_errors.ContainsKey(columnName))
                {
                    Debug.WriteLine("[Debug] this[" + columnName + "] = " + _errors[columnName]);
                    return _errors[columnName];
                }

                Debug.WriteLine("[Debug] this[" + columnName + "] = null");
                return null;
            }

            set
            {
                _errors[columnName] = value;
            }
        }

        private void ValidateAll()
        {
            this.Validate("Name");
            this.Validate("Age");
        }

        private void Validate(string propertyName)
        {
            Debug.WriteLine("[Debug] Validate: " + propertyName);
            switch (propertyName)
            {
                case "Name":
                    if (string.IsNullOrEmpty(this.Name) || this.Name.Trim().Length == 0)
                        this["Name"] = "Please enter your name";
                    else
                        this.ClearError("Name");
                    break;

                case "Age":
                    if (this.Age < 18)
                        this["Age"] = "Please enter your age  (must be 18 or older)";
                    else
                        this.ClearError("Age");
                    break;
            }
        }

        private void ClearError(string columnName)
        {
            if (_errors.ContainsKey(columnName))
            {
                _errors.Remove(columnName);
            }
        }

        #endregion

        #region Members

        private string _name;
        public string Name
        {
            get { return _name; }
            set
            {
                _name = value;
                this.RaisePropertyChanged("Name");
            }
        }

        private int _age;
        public int Age
        {
            get { return _age; }
            set
            {
                _age = value;
                this.RaisePropertyChanged("Age");
            }
        }

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

        #endregion
    }
}