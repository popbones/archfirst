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

namespace Bullsfirst.Module.Accounts.Views
{
    public partial class CreateNewAccountPopup : ChildWindow, INotifyPropertyChanged, IDataErrorInfo
    {
        #region Construction

        public CreateNewAccountPopup(CreateAccountRequest request)
        {
            InitializeComponent();
            _responseHandler = request.ResponseHandler;
            this.DataContext = this;

            CreateAccountCommand = new DelegateCommand<object>(this.CreateAccountExecute, this.CanCreateAccountExecute);
            CancelCommand = new DelegateCommand<object>(this.CancelExecute);
            this.PropertyChanged += this.OnPropertyChanged;
            this.Validate();
        }

        private void OnPropertyChanged(object sender, PropertyChangedEventArgs e)
        {
            this.Validate();
            this.CreateAccountCommand.RaiseCanExecuteChanged();
        }

        #endregion

        #region CreateAccountCommand

        public DelegateCommand<object> CreateAccountCommand { get; set; }

        private bool CanCreateAccountExecute(object dummyObject)
        {
            return _errors.Count == 0;
        }

        private void CreateAccountExecute(object dummyObject)
        {
            this.DialogResult = true;
            _responseHandler(new CreateAccountResponse
            {
                Result = true,
                AccountName = this.AccountName
            });
        }

        #endregion

        #region CancelCommand

        public DelegateCommand<object> CancelCommand { get; set; }

        private void CancelExecute(object dummyObject)
        {
            this.DialogResult = false;
            _responseHandler(new CreateAccountResponse { Result = false });
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

        private void Validate()
        {
            if (string.IsNullOrEmpty(this.AccountName) || this.AccountName.Trim().Length == 0)
                this["AccountName"] = "Please enter the account name";
            else
                this.ClearError("AccountName");
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

        private Action<CreateAccountResponse> _responseHandler;

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

        #endregion
    }
}