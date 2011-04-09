/*
 * From Adam Barney's blog entry:
 * http://blogs.adambarney.com/tech/2010/09/adding-propertychanged-updatesourcetrigger-mode-to-silverlight/
 */
using System.Windows.Controls;
using System.Windows.Interactivity;

namespace Archfirst.Framework.SilverlightHelpers
{
    public class TextChangedBahvior : Behavior<TextBox>
    {
        protected override void OnAttached()
        {
            base.OnAttached();
            AssociatedObject.TextChanged += TextBoxTextChanged;
        }

        protected override void OnDetaching()
        {
            base.OnDetaching();
            AssociatedObject.TextChanged-= TextBoxTextChanged;
        }

        private void TextBoxTextChanged(object sender, TextChangedEventArgs e)
        {
            var binding = AssociatedObject.GetBindingExpression(TextBox.TextProperty);
            if(binding != null)
                binding.UpdateSource();
        }
    }
}