/*
 * Based on http://stackoverflow.com/questions/5232683/expand-collapse-button-in-a-silverlight-datagrid
 */
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Interactivity;
using System.Windows.Media;

namespace Archfirst.Framework.SilverlightHelpers
{
    public class ExpandRowAction : TriggerAction<ToggleButton>
    {
        protected override void Invoke(object o)
        {
            var row = this.AssociatedObject.FindAncestor<DataGridRow>();
            if (row != null)
            {
                if (this.AssociatedObject.IsChecked == true)
                    row.DetailsVisibility = Visibility.Visible;
                else
                    row.DetailsVisibility = Visibility.Collapsed;
            }
        }
    }

    public static class DependencyObjectExtentions
    {
        /// <summary>
        /// Walk up the VisualTree, returning first parent object of the type supplied as type parameter
        /// </summary>
        public static T FindAncestor<T>(this DependencyObject obj) where T : DependencyObject
        {
            while (obj != null)
            {
                T o = obj as T;
                if (o != null)
                    return o;

                obj = VisualTreeHelper.GetParent(obj);
            }
            return null;
        }
    }
}