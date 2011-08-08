/*
 * Based on Domenic Denicola's post at
 * http://stackoverflow.com/questions/1281490/binding-comboboxes-to-enums-in-silverlight
 */
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Windows.Data;

namespace Archfirst.Framework.Converters
{
    public class EnumToIntConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            // Note: as pointed out by Martin in the comments on this answer, this line
            // depends on the enum values being sequentially ordered from 0 onward,
            // since combobox indices are done that way. A more general solution would
            // probably look up where in the GetValues array our value variable
            // appears, then return that index.
            return (int)value;
        }

        public object ConvertBack(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            return Enum.Parse(targetType, value.ToString(), true);
        }
    }
    public class EnumToIEnumerableConverter : IValueConverter
    {
        private Dictionary<Type, List<object>> cache = new Dictionary<Type, List<object>>();

        public object Convert(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            var type = value.GetType();
            if (!this.cache.ContainsKey(type))
            {
                var fields = type.GetFields().Where(field => field.IsLiteral);
                var values = new List<object>();
                foreach (var field in fields)
                {
                    DescriptionAttribute[] a = (DescriptionAttribute[])field.GetCustomAttributes(typeof(DescriptionAttribute), false);
                    if (a != null && a.Length > 0)
                    {
                        values.Add(a[0].Description);
                    }
                    else
                    {
                        values.Add(field.GetValue(value));
                    }
                }
                this.cache[type] = values;
            }

            return this.cache[type];
        }

        public object ConvertBack(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}