/*
Copyright (c) 2008 NascomASLib Contributors.  See:
    http://code.google.com/p/nascomaslib

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
package be.nascom.flash.validators
{
    /** 
	 * // will return a boolean
    * EmailValidator.isValidEmail("someone@someplace.com");
    * 
    * // if you'd rather validate an catch an error you can use:
    * EmailValidator.validate("someone@someplace.com");
    * 
    * // You can also specify which class you;d rather throw an error in case the email isn't valid:
    * EmailValidator.validate("bad@email@someplace.com", MyErrorClass);
    * 
    * // You can also specify the message to be passed to the error class
    * EmailValidator.validate("bad@email@someplace.com", Error, "Bad email!");
    * 
    * // If you have an input where people can type a few email addresses you can validate a whole list
    * // This will separate and trim each word of text:
    * EmailValidator.isValidEmailList("someone@someplace.com, afriend@otherplace.com");
    * 
    * // If you specify an arbitrary separator to test. This will return true:
    * EmailValidator.isValidEmailList("someone@someplace.com; afriend@otherplace.com ", ";");
    * // But using the default (",") separator, this will return false:
    * EmailValidator.isValidEmailList("someone@someplace.com; afriend@otherplace.com ",);
	 * 
 	 */
 	 
    public class EmailValidator
    {
        public function EmailValidator() 
        {
            throw new Error("The EmailValidator class is not intended to be instantiated.");
        }
        
        // permissive, will allow quite a few non matching email addresses
        public static const EMAIL_REGEX : RegExp = /^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)+[A-Z]{2,4}$/i;

        /** Checks if the given string is a valid email address.
        *  @param email The email address as a String
        *  @return True if the given string is a valid email address, false otherwise.
        */
        public static function isValidEmail(email : String) : Boolean
        {
            return Boolean(email.match(EMAIL_REGEX));
        }
        
        /* Splits a string with the separator character, strips white characters and checks if all of them are valid
        */
        public static function isValidEmailList(emailList : String, separator : String = ",") : Boolean
        {
            var addresses : Array = emailList.split(separator);
            for each (var email : String in addresses)
            {
                if (!isValidEmail(email.replace(/\s/, "")))return false;
            }
            return true;
        }
        
        public static function validate(email : String, errorClass : Class = null, errorMessage : String = "Invalid e-mail address.") : void
        {
            if (isValidEmail(email) )return;
            errorClass = errorClass || Error;
            throw new errorClass(errorMessage)
        }
    }
}