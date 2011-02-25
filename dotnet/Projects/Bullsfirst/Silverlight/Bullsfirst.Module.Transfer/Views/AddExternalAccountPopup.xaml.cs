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
using System.Windows.Controls;
using Microsoft.Practices.Prism.Commands;

namespace Bullsfirst.Module.Transfer.Views
{
    public partial class AddExternalAccountPopup : ChildWindow, INotifyPropertyChanged, IDataErrorInfo
    {
        #region Construction

        public AddExternalAccountPopup(AddExternalAccountRequest request)
        {
            InitializeComponent();
            _responseHandler = request.ResponseHandler;
            this.DataContext = this;

            AddExternalAccountCommand = new DelegateCommand<object>(this.AddExternalAccountExecute, this.CanAddExternalAccountExecute);
            CancelCommand = new DelegateCommand<object>(this.CancelExecute);
            this.PropertyChanged += this.OnPropertyChanged;
            this.ValidateAll();
        }

        private void OnPropertyChanged(object sender, PropertyChangedEventArgs e)
        {
            this.Validate(e.PropertyName);
            this.AddExternalAccountCommand.RaiseCanExecuteChanged();
        }

        #endregion

        #region AddExternalAccountCommand

        public DelegateCommand<object> AddExternalAccountCommand { get; set; }

        private bool CanAddExternalAccountExecute(object dummyObject)
        {
            return _errors.Count == 0;
        }

        private void AddExternalAccountExecute(object dummyObject)
        {
            this.DialogResult = true;
            _responseHandler(new AddExternalAccountResponse
            {
                Result = true,
                AccountName = this.AccountName,
                RoutingNumber = this.RoutingNumber,
                AccountNumber = this.AccountNumber
            });
        }

        #endregion

        #region CancelCommand

        public DelegateCommand<object> CancelCommand { get; set; }

        private void CancelExecute(object dummyObject)
        {
            this.DialogResult = false;
            _responseHandler(new AddExternalAccountResponse { Result = false });
        }

        #endregion

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
                    return _errors[columnName];
                }

                return null;
            }

            set
            {
                _errors[columnName] = value;
            }
        }

        private void ValidateAll()
        {
            this.Validate("AccountName");
            this.Validate("RoutingNumber");
            this.Validate("AccountNumber");
        }

        private void Validate(string propertyName)
        {
            switch (propertyName)
            {
                case "AccountName":
                    if (string.IsNullOrEmpty(this.AccountName) || this.AccountName.Trim().Length == 0)
                        this["AccountName"] = "Please enter the account name";
                    else
                        this.ClearError("AccountName");
                    break;

                case "RoutingNumber":
                    if (string.IsNullOrEmpty(this.RoutingNumber) || this.RoutingNumber.Trim().Length == 0)
                        this["RoutingNumber"] = "Please enter the routing number";
                    else
                        this.ClearError("RoutingNumber");
                    break;

                case "AccountNumber":
                    if (string.IsNullOrEmpty(this.AccountNumber) || this.AccountNumber.Trim().Length == 0)
                        this["AccountNumber"] = "Please enter the account number";
                    else
                        this.ClearError("AccountNumber");
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

        private Action<AddExternalAccountResponse> _responseHandler;

        private string _accountName;
        public string AccountName
        {
            get { return _accountName; }
            set
            {
                _accountName = value;
                this.RaisePropertyChanged("AccountName");
            }
        }

        private string _routingNumber;
        public string RoutingNumber
        {
            get { return _routingNumber; }
            set
            {
                _routingNumber = value;
                this.RaisePropertyChanged("RoutingNumber");
            }
        }

        private string _accountNumber;
        public string AccountNumber
        {
            get { return _accountNumber; }
            set
            {
                _accountNumber = value;
                this.RaisePropertyChanged("AccountNumber");
            }
        }

        #endregion
    }
}