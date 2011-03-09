/* Copyright 2011 Archfirst
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
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Interactivity;
using System.Windows.Media;

namespace Archfirst.Framework.SilverlightHelpers
{
    /// <summary>
    /// Based on http://stackoverflow.com/questions/5232683/expand-collapse-button-in-a-silverlight-datagrid
    /// </summary>
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