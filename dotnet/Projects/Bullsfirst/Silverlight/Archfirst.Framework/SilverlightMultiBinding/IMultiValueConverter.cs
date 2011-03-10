/*
 * From Colin Eberhardt's post at
 * http://www.scottlogic.co.uk/blog/colin/2010/05/silverlight-multibinding-solution-for-silverlight-4/
 */
using System;
using System.Globalization;

namespace Archfirst.Framework.SilverlightMultiBinding
{
    /// <summary>
    /// see: http://msdn.microsoft.com/en-us/library/system.windows.data.imultivalueconverter.aspx
    /// </summary>
    public interface IMultiValueConverter
    {
        object Convert(object[] values, Type targetType, object parameter, CultureInfo culture);

        object[] ConvertBack(object value, Type[] targetTypes, object parameter, CultureInfo culture);

    }
}