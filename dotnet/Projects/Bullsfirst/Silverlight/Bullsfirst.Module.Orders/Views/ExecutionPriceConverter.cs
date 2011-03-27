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

namespace Bullsfirst.Module.Orders.Views
{
    /// <summary>
    /// Looks at Order.Execution to determine execution price.
    /// </summary>
    public class ExecutionPriceConverter : IValueConverter
    {
        /// <summary>
        /// Used to modify data as it is bound from the source object to the control.
        /// Converts Order.Execution to a String (Money)
        /// </summary>
        public object Convert(
            object value, Type targetType, object parameter, CultureInfo culture)
        {
            Order order = value as Order;
            if (order != null && order.Execution != null && order.Execution.Length > 0)
            {
                decimal totalPrice = 0.00M;
                decimal totalQuantity = 0.00M;
                foreach (Execution execution in order.Execution)
                {
                    totalPrice += execution.Price.Amount * execution.Quantity;
                    totalQuantity += execution.Quantity;
                }
                decimal executionPrice = totalPrice / totalQuantity;
                return executionPrice.ToString("C");
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// Used to modify data as it is saved from the control to the source object.
        /// Converts String to Order.Execution
        /// But this case never happens, so throw exception
        /// </summary>
        public object ConvertBack(
            object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}