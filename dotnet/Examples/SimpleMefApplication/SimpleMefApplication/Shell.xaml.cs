using System.ComponentModel.Composition;
using System.Windows.Controls;

namespace SimpleMefApplication
{
    [Export]
    public partial class Shell : UserControl
    {
        public Shell()
        {
            InitializeComponent();
        }
    }
}
