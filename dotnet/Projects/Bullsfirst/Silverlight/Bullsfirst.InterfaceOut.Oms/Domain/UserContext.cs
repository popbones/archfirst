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
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.ComponentModel.Composition;
using Bullsfirst.InterfaceOut.Oms.SecurityServiceReference;
using Bullsfirst.InterfaceOut.Oms.TradingServiceReference;

namespace Bullsfirst.InterfaceOut.Oms.Domain
{
    [Export]
    [PartCreationPolicy(CreationPolicy.Shared)]
    public class UserContext : INotifyPropertyChanged
    {
        public UserContext()
        {
            User = new User();
            Credentials = new Credentials();
            AccountSummaries = new ObservableCollection<AccountSummary>();
        }

        public void InitUser(User other)
        {
            InitUser(other.Username, other.FirstName, other.LastName);
        }

        public void InitUser(string username, string firstName, string lastName)
        {
            User.Username = username;
            User.FirstName = firstName;
            User.LastName = lastName;
        }

        public void InitCredentials(string username, string password)
        {
            Credentials.Username = username;
            Credentials.Password = password;
        }

        public void Reset()
        {
            this.InitUser(new User());
            this.InitCredentials(null, null);
            AccountSummaries.Clear();
            SelectedAccount = null;
        }

        public AccountSummary FindAccount(long id)
        {
            AccountSummary result = null;
            for (int index = 0; index < AccountSummaries.Count; index++)
            {
                if (AccountSummaries[index].Id == id)
                {
                    result = AccountSummaries[index];
                    break;
                }
            }

            return result;
        }

        public void InitializeAccountSummaries(AccountSummary[] summaries)
        {
            if (summaries == null) return;

            // Remember currently selected account
            long currentlySelectedAccount = (SelectedAccount != null) ? SelectedAccount.Id : 0;

            AccountSummaries.Clear();
            foreach (AccountSummary summary in summaries)
            {
                AccountSummaries.Add(summary);
            }

            // Restore currently selected account (with the new instance of AccountSummary)
            if (currentlySelectedAccount != 0)
            {
                SelectedAccount = FindAccount(currentlySelectedAccount);
            }
            if (SelectedAccount == null && AccountSummaries.Count != 0)
            {
                SelectedAccount = AccountSummaries[0];
            }
        }

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

        #region Members

        public User User { get; set; }
        public Credentials Credentials { get; set; }
        public ObservableCollection<AccountSummary> AccountSummaries { get; set; }

        private AccountSummary _selectedAccount;
        public AccountSummary SelectedAccount
        {
            get { return _selectedAccount; }
            set
            {
                _selectedAccount = value;
                this.RaisePropertyChanged("SelectedAccount");
            }
        }

        #endregion
    }
}