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
using System.ComponentModel.Composition;
using Bullsfirst.InterfaceOut.Oms.Domain;
using Bullsfirst.Module.Transfer.Interfaces;
using Microsoft.Practices.Prism.Commands;
using Microsoft.Practices.Prism.Logging;
using Microsoft.Practices.Prism.ViewModel;

namespace Bullsfirst.Module.Transfer.ViewModels
{
    [Export(typeof(ITransferViewModel))]
    [PartCreationPolicy(CreationPolicy.NonShared)]
    public class TransferViewModel : NotificationObject, ITransferViewModel
    {
        #region Construction

        [ImportingConstructor]
        public TransferViewModel(
            ILoggerFacade logger,
            UserContext userContext)
        {
            logger.Log("TransferViewModel.TransferViewModel()", Category.Debug, Priority.Low);
            _logger = logger;
            this.UserContext = userContext;
        }

        #endregion

        #region Commands

        public DelegateCommand<object> TransferCommand { get; set; }
        public DelegateCommand<object> AddExternalAccountCommand { get; set; }

        #endregion

        #region Members

        private ILoggerFacade _logger;
        public UserContext UserContext { get; set; }

        public string ViewTitle
        {
            get { return "Transfer"; }
        }

        private TransferKind _transferKind = TransferKind.Cash;
        public TransferKind TransferKind
        {
            get { return _transferKind; }
            set
            {
                _transferKind = value;
                RaisePropertyChanged("TransferKind");
            }
        }

        private BaseAccountDisplayObject _fromAccount;
        public BaseAccountDisplayObject FromAccount
        {
            get { return _fromAccount; }
            set
            {
                _fromAccount = value;
                this.RaisePropertyChanged("FromAccount");
            }
        }

        private BaseAccountDisplayObject _toAccount;
        public BaseAccountDisplayObject ToAccount
        {
            get { return _toAccount; }
            set
            {
                _toAccount = value;
                this.RaisePropertyChanged("ToAccount");
            }
        }

        private decimal _amount;
        public decimal Amount
        {
            get { return _amount; }
            set
            {
                _amount = value;
                this.RaisePropertyChanged("Amount");
            }
        }

        private string _symbol;
        public string Symbol
        {
            get { return _symbol; }
            set
            {
                _symbol = value;
                this.RaisePropertyChanged("Symbol");
            }
        }

        private decimal _quantity;
        public decimal Quantity
        {
            get { return _quantity; }
            set
            {
                _quantity = value;
                this.RaisePropertyChanged("Quantity");
            }
        }

        private decimal _pricePaidPerShare;
        public decimal PricePaidPerShare
        {
            get { return _pricePaidPerShare; }
            set
            {
                _pricePaidPerShare = value;
                this.RaisePropertyChanged("PricePaidPerShare");
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