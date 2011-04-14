/*
 * Based on Adam Barney's blog entry:
 * http://blogs.adambarney.com/tech/2010/09/adding-propertychanged-updatesourcetrigger-mode-to-silverlight/
 */
using System.Windows;
using System.Windows.Controls;
using System.Windows.Interactivity;

namespace Archfirst.Framework.SilverlightHelpers
{
    public class PasswordChangedBehavior : Behavior<PasswordBox>
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