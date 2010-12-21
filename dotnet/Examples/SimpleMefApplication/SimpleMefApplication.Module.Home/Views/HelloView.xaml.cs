using System.ComponentModel.Composition;
using System.Windows.Controls;
using SimpleMefApplication.Infrastructure;
using SimpleMefApplication.Module.Home.Interfaces;

namespace SimpleMefApplication.Module.Home.Views
{
    [ViewExport(RegionName = "HomeContentRegion")]
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