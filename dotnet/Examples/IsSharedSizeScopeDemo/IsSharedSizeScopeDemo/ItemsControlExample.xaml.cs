using System.Collections.Generic;
using System.Windows.Controls;

namespace IsSharedSizeScopeDemo
{
    /// <summary>
    /// Interaction logic for ItemsControlExample.xaml
    /// </summary>
    public partial class ItemsControlExample : UserControl
    {
        public ItemsControlExample()
        {
            InitializeComponent();
            this.DataContext = Capitals;
        }

        private Dictionary<string, string> _capitals;
        public Dictionary<string, string> Capitals
        {
            get
            {
                if (_capitals == null)
                {
                    _capitals = new Dictionary<string, string>
                    {
                        {"Alabama", "Montgomery"},
                        {"California", "Sacramento"},
                        {"Iowa", "Des Moines"},
                        {"Massachusetts", "Boston"}
                    };
                }
                return _capitals;
            }
        }
    }
}