using System.ComponentModel.Composition;
using System.Windows.Input;
using Microsoft.Practices.Prism.Commands;
using Microsoft.Practices.Prism.ViewModel;
using SimpleMefApplication.Module.Home.Interfaces;

namespace SimpleMefApplication.Module.Home.ViewModels
{
    [Export(typeof(IHelloViewModel))]
    [PartCreationPolicy(CreationPolicy.NonShared)]
    public class HelloViewModel : NotificationObject, IHelloViewModel
    {
        public HelloViewModel()
        {
            this.SubmitCommand = new DelegateCommand<object>(this.SubmitExecute);
        }

        #region SubmitCommand

        public ICommand SubmitCommand { get; private set; }

        private void SubmitExecute(object obj)
        {
            Message = "Hello " + Name;
        }

        #endregion

        #region Members

        private string _name;
        public string Name
        {
            get { return _name; }
            set
            {
                if (value != _name)
                {
                    _name = value;
                    this.RaisePropertyChanged("Name");
                }
            }
        }

        private string _message;
        public string Message
        {
            get { return _message; }
            set
            {
                if (value != _message)
                {
                    _message = value;
                    this.RaisePropertyChanged("Message");
                }
            }
        }

        #endregion // Members
    }
}