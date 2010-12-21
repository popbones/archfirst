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
using System.Windows;
using System.Windows.Controls;
using System.Windows.Interactivity;

namespace Archfirst.Framework.SilverlightHelpers
{
    /// <summary>
    /// Based on Adam Barney's blog entry:
    /// http://blogs.adambarney.com/tech/2010/09/adding-propertychanged-updatesourcetrigger-mode-to-silverlight/
    /// </summary>
    public class PasswordChangedBahvior : Behavior<PasswordBox>
    {
        protected override void OnAttached()
        {
            base.OnAttached();
            AssociatedObject.PasswordChanged += PasswordBoxPasswordChanged;
        }

        protected override void OnDetaching()
        {
            base.OnDetaching();
            AssociatedObject.PasswordChanged -= PasswordBoxPasswordChanged;
        }

        private void PasswordBoxPasswordChanged(object sender, RoutedEventArgs e)
        {
            var binding = AssociatedObject.GetBindingExpression(PasswordBox.PasswordProperty);
            if (binding != null)
                binding.UpdateSource();
        }
    }
}