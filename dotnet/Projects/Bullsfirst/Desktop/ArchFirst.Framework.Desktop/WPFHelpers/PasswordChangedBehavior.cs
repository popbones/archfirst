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
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Controls;
using System.Windows.Interactivity;
using System.Windows;
using System.Windows.Input;
using System.Windows.Media;

namespace Archfirst.Framework.Desktop.WPFHelpers
{
    public class PasswordChangedBehavior: Behavior<PasswordBox>
    {
        public static readonly DependencyProperty PasswordChangedCommandProperty = DependencyProperty.RegisterAttached("PasswordChangedCommand",
            typeof(ICommand), 
            typeof(PasswordChangedBehavior), 
            new PropertyMetadata(null));

        public static ICommand GetPasswordChangedCommand(DependencyObject target)
        {
            return (ICommand)target.GetValue(PasswordChangedCommandProperty);
        }

        public static void SetPasswordChangedCommand(DependencyObject target,ICommand newValue)
        {
            target.SetValue(PasswordChangedCommandProperty,newValue);
        }

        public static readonly DependencyProperty PasswordHasValidationErrorProperty = DependencyProperty.RegisterAttached("PasswordHasValidationError",
            typeof(bool),
            typeof(PasswordChangedBehavior),
            new PropertyMetadata(PasswordValidationStateChanged));

        public static bool GetPasswordHasValidationError(DependencyObject target)
        {
            return (bool)target.GetValue(PasswordHasValidationErrorProperty);
        }

        public static void SetPasswordHasValidationError(DependencyObject target,bool newValue)
        {
            target.SetValue(PasswordHasValidationErrorProperty,newValue);
        }


        protected override void OnAttached()
        {
            base.OnAttached();
            AssociatedObject.PasswordChanged += PasswordBoxPasswordChanged;

            AssociatedObject.GotKeyboardFocus += new KeyboardFocusChangedEventHandler(AssociatedObject_GotKeyboardFocus);
        }

        void AssociatedObject_GotKeyboardFocus(object sender, KeyboardFocusChangedEventArgs e)
        {
            SetPasswordHasValidationError(AssociatedObject, true);
        }

        protected override void OnDetaching()
        {
            base.OnDetaching();
            AssociatedObject.PasswordChanged -= PasswordBoxPasswordChanged;
            
        }

        private void PasswordBoxPasswordChanged(object sender, RoutedEventArgs e)
        {
            if (string.IsNullOrEmpty(AssociatedObject.Password))
            {
                AssociatedObject.SetValue(PasswordHasValidationErrorProperty, true);
            }
            else
            {
                AssociatedObject.SetValue(PasswordHasValidationErrorProperty, false);

                var command = (ICommand)AssociatedObject.GetValue(PasswordChangedCommandProperty);

                if (command != null)
                    command.Execute(AssociatedObject.Password);
            }
        }


        private static void PasswordValidationStateChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            PasswordBox pBox = d as PasswordBox;

            if ((bool)e.NewValue == true)
            {
                Validation.MarkInvalid(pBox.GetBindingExpression(PasswordChangedCommandProperty), new ValidationError(new ExceptionValidationRule(), pBox.GetBindingExpression(PasswordChangedCommandProperty), "Please enter password", null));
            }
            else
            {
                Validation.ClearInvalid(pBox.GetBindingExpression(PasswordChangedCommandProperty));
            }

        }
    }
}
