using System.ComponentModel.Composition;
using System.Windows.Controls;
using SimpleMefApplication.Infrastructure;

namespace SimpleMefApplication.Module.Home.Views
{
    [ViewExport(RegionName = "MainRegion")]
    [PartCreationPolicy(CreationPolicy.NonShared)]
    public partial class HomeView : UserControl
    {
        public HomeView()
        {
            InitializeComponent();
        }
    }
}