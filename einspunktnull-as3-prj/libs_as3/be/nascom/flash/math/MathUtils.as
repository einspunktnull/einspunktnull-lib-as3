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

package be.nascom.flash.math
{
	/**
	 * The MathUtilities class contains methods built upon the Math package.
	 * 
	 * @author Geert Bollen
	 * @mail geert.bollen@nascom.be
	 */
 	 
	public class MathUtils
	{
		/**
		 * Returns a random Number between the specified values.
		 * 
		 * @param min The lowest value
		 * @param max The highest value
		 * @param float The amount of digits behind the floating point
		 */
		public static function randomNumber(min:Number, max:Number, float:uint=0):Number
		{
			var random:Number;
			var floatFactor:uint;
			
			floatFactor = Math.pow(10, float);
			max *=  floatFactor;
			min *=  floatFactor;
			random = Math.floor(Math.random() * (max - min)) + min;
			random = random/floatFactor;
			
			return random;
		}
		
		/**
		 * Returns a random positive (1) or negatie (-1) value.
		 */
		public static function randomNegation():int
		{
			var random:Number;
			var output:int;
			
			random = Math.random();
			if(random > 0.5)
				output = 1;
			else
				output = -1;
			
			return output;
		}
		
		/**
		 * Returns the shortest rotation angle between two angles.
		 */
		public static function getShortestAngle(currentAngle:Number, angleTo:Number):Number
		{
			return Math.atan2(Math.sin(angleTo - currentAngle), Math.cos(angleTo - currentAngle));
		}	
		
		/**
		 * Returns bytes to formatted MB's string.
		 * For example, if bytesTotal = 5024322 the output would be ... mbFormatted: 4.79 MB
		 * 
		 */
		public static function getBytesAsMegabytes(bytes:Number):String
		{
			return (Math.floor(((bytes/1024/ 1024)*100))/100)+" MB";;
		}
		
		/**
		 * Returns a random color.
		 */
		public static function randomColor():uint
		{
			return Math.random() * 0xFFFFFF;
		}
		
		/**
		 * Returns a boolean if even or odd number.
		 */
		public static function isEven(num:Number):Boolean
		{
			return !(num%2);
		}
	}
}