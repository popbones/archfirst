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
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using System.Windows.Data;
using System.Globalization;
using Microsoft.Practices.Prism.Logging;

namespace Bullsfirst.Infrastructure.Controls
{
    public class CategoryToBrushConverter : IValueConverter
    {
        private static SolidColorBrush brushBlack = new SolidColorBrush(Colors.Black);
        private static SolidColorBrush brushGreen = new SolidColorBrush(Colors.Green);
        private static SolidColorBrush brushBrown = new SolidColorBrush(Colors.Brown);
        private static SolidColorBrush brushRed = new SolidColorBrush(Colors.Red);

        /// <summary>
        /// Used to modify data as it is bound from the source object to the control.
        /// Converts Category to a Brush
        /// </summary>
        public object Convert(
            object value, Type targetType, object parameter, CultureInfo culture)
        {
            Brush brush = null; ;

            Category category = (Category)value;
            switch (category)
            {
                case Category.Debug:
                    brush = brushBlack;
                    break;
                case Category.Info:
                    brush = brushGreen;
                    break;
                case Category.Warn:
                    brush = brushBrown;
                    break;
                case Category.Exception:
                    brush = brushRed;
                    break;
            }

            return brush;
        }

        /// <summary>
        /// Used to modify data as it is saved from the control to the source object.
        /// Converts Brush to a Category
        /// But this case never happens, so throw exception
        /// </summary>
        public object ConvertBack(
            object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}