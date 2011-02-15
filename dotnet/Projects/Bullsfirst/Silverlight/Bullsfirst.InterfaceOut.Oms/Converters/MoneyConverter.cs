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
using System.Globalization;
using System.Windows;
using System.Windows.Data;
using Bullsfirst.InterfaceOut.Oms.TradingServiceReference;

namespace Bullsfirst.InterfaceOut.Oms.Converters
{
    /// <summary>
    /// Converts Money to string and back. Does not accept currency component.
    /// </summary>
    public class MoneyConverter : IValueConverter
    {
        /// <summary>
        /// Used to modify data as it is bound from the source object to the control.
        /// Converts Money to a string
        /// </summary>
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            Money money = value as Money;
            return (money == null) ? null : String.Format("{0:0.00}", money.Amount);
        }

        /// <summary>
        /// Used to modify data as it is saved from the control to the source object.
        /// Converts string to Money
        /// 
        /// Can't use decimal.Parse() because it can throw a FormatException which messes up the
        /// binding engine. Here's a remark from IValueConverter.ConvertBack method documentation:
        /// 
        /// "The data binding engine does not catch exceptions that are thrown by a user-supplied
        /// converter. Any exception that is thrown by the ConvertBack method, or any uncaught
        /// exceptions that are thrown by methods that the ConvertBack method calls, are treated
        /// as run-time errors. Handle anticipated problems by returning DependencyProperty.UnsetValue."
        /// </summary>
        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            decimal amount;
            bool success = decimal.TryParse((string)value, out amount);
            return success ? new Money { Amount=amount, Currency="USD" } : DependencyProperty.UnsetValue;
        }
    }
}