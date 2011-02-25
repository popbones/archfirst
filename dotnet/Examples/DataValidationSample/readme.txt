This sample shows what's needed to do good data validation in Silverlight.

Note the Binding attributes on the Age text box in SampleView.xaml:

<TextBox
    Text="{Binding Path=Age,
           Mode=TwoWay,
           ValidatesOnExceptions=True,
           ValidatesOnDataErrors=True,
           NotifyOnValidationError=True}" />

First note that this is a two way binding which means that changes in the textbox should be applied back to the source, which is the Age property in the ViewModel.

ValidatesOnExceptions=True tells the binding engine to catch exceptions that occur when updating the source object from the target and add an error to the binding. For example, if the user types "xyz" in the Age box a System.FormatException is thrown and the following error message is shown: "Input is not in a correct format".

ValidatesOnDataErrors=True comes into play after the input has been converted successfully and stored in the source (Age property in the ViewModel). It tells the binding engine to catch data validation errors (triggered by the IDataErrorInfo interface) and add them to the binding. For example, if the user entered 10 and the minimum age required in that field is 18, then an error message will be shown.

NotifyOnValidationError=True tells the binding engine to raise the  BindingValidationError event on exceptions. This event can be caught in the code-behind to take an appropriate action. I haven't found a good use for the event handler, however setting NotifyOnValidationError to True is essential to reset the red color on the field label once the user has corrected an error.

Below are some sample calling sequences for various use case.

Age changing from 2 (invalid) to 20 (valid)
===========================================
[Debug] OnPropertyChanged: Age
[Debug] Validate: Age
[Debug] CanSubmitExecute: error count = 0
[Debug] age_BindingValidationError: Action=Removed, Error=Please enter your age  (must be 18 or older)
[Debug] this[Age] = null

Age changing from 20 (valid) to 2 (invalid)
===========================================
[Debug] OnPropertyChanged: Age
[Debug] Validate: Age
[Debug] CanSubmitExecute: error count = 1
[Debug] this[Age] = Please enter your age  (must be 18 or older)
[Debug] age_BindingValidationError: Action=Added, Error=Please enter your age  (must be 18 or older)

Age changing from 20 (valid) to 20r (invalid)
=============================================
System.Windows.Data Error: ConvertBack cannot convert value '20r' (type 'System.String'). BindingExpression: Path='Age' DataItem='DataValidationSample.SampleViewModel' (HashCode=50145638); target element is 'System.Windows.Controls.TextBox' (Name='age'); target property is 'Text' (type 'System.String').. System.FormatException: Input string was not in a correct format.
   at System.Number.StringToNumber(String str, NumberStyles options, NumberBuffer& number, NumberFormatInfo info, Boolean parseDecimal)
   at System.Number.ParseInt32(String s, NumberStyles style, NumberFormatInfo info)
   at System.String.System.IConvertible.ToInt32(IFormatProvider provider)
   at System.Convert.ChangeType(Object value, Type conversionType, IFormatProvider provider)
   at MS.Internal.Data.SystemConvertConverter.Convert(Object o, Type type, Object parameter, CultureInfo culture)
   at MS.Internal.Data.DynamicValueConverter.Convert(Object value, Type targetType, Object parameter, CultureInfo culture)
   at System.Windows.Data.BindingExpression.UpdateValue().
[Debug] age_BindingValidationError: Action=Added, Error=Input is not in a correct format.

Setting the binding attributes as discussed in this article provides very tight data validation. The only caveat is a glitch in disabling the command button when going from valid to invalid state due to a validation exception (use case #3 above). In this case the textbox indeed turns red and shows an error message, but the Submit button is still active. The reason for this is that the setter on the property is not called which prevents the chain reaction leading to the CanSubmitExecute() call.