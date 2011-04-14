/*
 * Based on Adam Barney's blog entry (does special handling for decimal point characters):
 * http://blogs.adambarney.com/tech/2010/09/adding-propertychanged-updatesourcetrigger-mode-to-silverlight/
 */
using System.Windows.Controls;
using System.Windows.Interactivity;

namespace Archfirst.Framework.SilverlightHelpers
{
    public class DecimalChangedBehavior : Behavior<TextBox>
    {
        protected override void OnAttached()
        {
            base.OnAttached();
            AssociatedObject.TextChanged += TextBoxTextChanged;
        }

        protected override void OnDetaching()
        {
            base.OnDetaching();
            AssociatedObject.TextChanged -= TextBoxTextChanged;
        }

        private void TextBoxTextChanged(object sender, TextChangedEventArgs e)
        {
            var binding = AssociatedObject.GetBindingExpression(TextBox.TextProperty);

            TextBox textBox = sender as TextBox;
            string text = textBox.Text;

            // Make sure text does not end with a decimal point otherwise it will fail validation
            // and the decimal point will disappear. In this special case simply don't update the source.
            if (binding != null && !text.EndsWith("."))
                binding.UpdateSource();
        }
    }
}