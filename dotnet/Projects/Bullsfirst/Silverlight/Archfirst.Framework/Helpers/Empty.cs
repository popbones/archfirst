/*
 * Based on "Empty Type Parameters" blog entry:
 * http://blog.davidpadbury.com/2010/01/01/empty-type-parameters/
 */

namespace Archfirst.Framework.Helpers
{
    public class Empty
    {
        private Empty()
        {
        }

        private static readonly Empty _value = new Empty();
        public static Empty Value
        {
            get { return _value; }
        }
    }
}