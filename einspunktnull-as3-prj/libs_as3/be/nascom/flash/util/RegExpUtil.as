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
package be.nascom.flash.util
{
	/** 
	 * RegExpUtil is used to filter out unwanted chars from string values.
	 *   
	 * @author Rien Verbrugghe
	 * @mail rien.verbrugghe@nascom.be
	 * 
	 */
	public class RegExpUtil
	{
		public static function filterAllowedCharsFromEmail(email:String):String
		{
			var onlyValidEmailCharsRegExp:RegExp = /[^0-9A-Za-z@_.\-]/g;
			return email.replace(onlyValidEmailCharsRegExp, "");
		}
		
		public static function filterOnlyNumbersFromString(value:String):Number
		{
			var onlyNumbersRegExp:RegExp = /[^0-9]/g;
			return new Number(value.replace(onlyNumbersRegExp, ""));
		}
		
		public static function filterOnlyCharsFromString(value:String):String
		{
			var noNumbersRegExp:RegExp = /[0-9]/g;
			return value.replace(noNumbersRegExp, "");
		}
	}
}