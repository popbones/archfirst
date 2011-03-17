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
using System.Windows;
using System.Windows.Data;
using Bullsfirst.Module.Transfer.ViewModels;

namespace Bullsfirst.Module.Transfer.Views
{
    public class TransferKindBooleanConverter : IValueConverter
    {
        /// <summary>
        /// Converts TransferKind enum value (in ViewModel) to boolean, setting the state of the radio button
        /// </summary>
        public object Convert(
            object value, System.Type targetType,
            object parameter, System.Globalization.CultureInfo culture)
        {
            string parameterString = parameter as string;
            if (parameterString == null)
                return DependencyProperty.UnsetValue;

            if (Enum.IsDefined(value.GetType(), value) == false)
                return DependencyProperty.UnsetValue;

            object parameterValue = Enum.Parse(value.GetType(), parameterString, false);

            return parameterValue.Equals(value);
        }

        /// <summary>
        /// Converts the string coming from the radio button to an enum, to set the value in the ViewModel
        /// </summary>
        public object ConvertBack(
            object value, System.Type targetType,
            object parameter, System.Globalization.CultureInfo culture)
        {
            string parameterString = parameter as string;
            if (parameterString == null)
                return DependencyProperty.UnsetValue;

            return Enum.Parse(targetType, parameterString, false);
        }
    }

    public class TransferKindCashVisibilityConverter : IValueConverter
    {
        public object Convert(
            object value, System.Type targetType,
            object parameter, System.Globalization.CultureInfo culture)
        {
            return ((TransferKind)value) == TransferKind.Cash ? Visibility.Visible : Visibility.Collapsed;
        }

        public object ConvertBack(
            object value, System.Type targetType,
            object parameter, System.Globalization.CultureInfo culture)
        {
            throw new System.NotImplementedException();
        }
    }

    public class TransferKindSecuritiesVisibilityConverter : IValueConverter
    {
        public object Convert(
            object value, System.Type targetType,
            object parameter, System.Globalization.CultureInfo culture)
        {
            return ((TransferKind)value) == TransferKind.Securities ? Visibility.Visible : Visibility.Collapsed;
        }

        public object ConvertBack(
            object value, System.Type targetType,
            object parameter, System.Globalization.CultureInfo culture)
        {
            throw new System.NotImplementedException();
        }
    }
}