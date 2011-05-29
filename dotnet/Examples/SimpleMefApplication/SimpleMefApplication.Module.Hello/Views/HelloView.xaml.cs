using System.ComponentModel.Composition;
using System.Windows.Controls;
using SimpleMefApplication.Infrastructure;
using SimpleMefApplication.Module.Hello.Interfaces;

namespace SimpleMefApplication.Module.Hello.Views
{
    [ViewExport(RegionName = "MainRegion")]
    [PartCreationPolicy(CreationPolicy.NonShared)]
    public partial class HelloView : UserControl
    {
        public HelloView()
        {
            InitializeComponent();
        }

        [Import]
        public IHelloViewModel ViewModel
        {
            set { this.DataContext = value; }
        }
    }
}