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
            BrokerageAccountSummaries = new ObservableCollection<BrokerageAccountSummary>();
            ExternalAccountSummaries = new ObservableCollection<ExternalAccountSummary>();
            BaseAccountWrappers = new ObservableCollection<BaseAccountWrapper>();
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
            BrokerageAccountSummaries.Clear();
            ExternalAccountSummaries.Clear();
            BaseAccountWrappers.Clear();
            SelectedAccount = null;
        }

        public BrokerageAccountSummary FindBrokerageAccount(long id)
        {
            BrokerageAccountSummary result = null;
            foreach (BrokerageAccountSummary summary in BrokerageAccountSummaries)
            {
                if (summary.Id == id)
                {
                    result = summary;
                    break;
                }
            }

            return result;
        }

        public void InitializeBrokerageAccountSummaries(BrokerageAccountSummary[] summaries)
        {
            if (summaries == null) return;

            // Remember currently selected account
            long currentlySelectedAccount = (SelectedAccount != null) ? SelectedAccount.Id : 0;

            BrokerageAccountSummaries.Clear();
            foreach (BrokerageAccountSummary summary in summaries)
            {
                BrokerageAccountSummaries.Add(summary);
            }

            // Restore currently selected account (with the new instance of AccountSummary)
            if (currentlySelectedAccount != 0)
            {
                SelectedAccount = FindBrokerageAccount(currentlySelectedAccount);
            }
            if (SelectedAccount == null && BrokerageAccountSummaries.Count != 0)
            {
                SelectedAccount = BrokerageAccountSummaries[0];
            }
        }

        public void InitializeExternalAccountSummaries(ExternalAccountSummary[] summaries)
        {
            if (summaries == null) return;

            ExternalAccountSummaries.Clear();
            foreach (ExternalAccountSummary summary in summaries)
            {
                ExternalAccountSummaries.Add(summary);
            }
        }

        public void InitializeBaseAccountWrappers()
        {
            BaseAccountWrappers.Clear();
            foreach (BrokerageAccountSummary summary in BrokerageAccountSummaries)
            {
                BaseAccountWrappers.Add(new BaseAccountWrapper(summary));
            }
            foreach (ExternalAccountSummary summary in ExternalAccountSummaries)
            {
                BaseAccountWrappers.Add(new BaseAccountWrapper(summary));
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
        public ObservableCollection<BrokerageAccountSummary> BrokerageAccountSummaries { get; set; }
        public ObservableCollection<ExternalAccountSummary> ExternalAccountSummaries { get; set; }
        public ObservableCollection<BaseAccountWrapper> BaseAccountWrappers { get; set; }

        private BrokerageAccountSummary _selectedAccount;
        public BrokerageAccountSummary SelectedAccount
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