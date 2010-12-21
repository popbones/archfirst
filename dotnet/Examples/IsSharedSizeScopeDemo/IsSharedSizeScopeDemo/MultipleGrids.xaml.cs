using System.Collections.Generic;
using System.Windows.Controls;

namespace IsSharedSizeScopeDemo
{
    /// <summary>
    /// Interaction logic for MultipleGrids.xaml
    /// </summary>
    public partial class MultipleGrids : UserControl
    {
        public MultipleGrids()
        {
            InitializeComponent();
        }

        private void SetFalse_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            Grid.SetIsSharedSizeScope(Container, false);
        }

        private void SetTrue_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            Grid.SetIsSharedSizeScope(Container, true);
        }
    }
}
