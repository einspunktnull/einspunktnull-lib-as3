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
	import flash.display.Sprite;
	
	/**
	 * The ArrayUtil class contains methods to perform actions on arrays.
	 * 
	 * @author Rien Verbrugghe
	 * @mail rien.verbrugghe@nascom.be
	 */
	public class ArrayUtil 
	{			
		/**
		 * function search finds element in array and displays result
		 **/	
		public static function search(word:Object, arr:Array):Number 
		{
				var result:Number;
				var exists:Boolean = false;
				for(var i:uint=0; i < arr.length; i++){
					if(arr[i]==word){
						result = i;
						exists = true;
					}
				}
				if(!(exists)){
					result = NaN;
				}
				
				return result;
		}
			
		/**
		 * function function searchB finds element in array and returns Boolean value
		 **/	
		public static function searchB(word:Object, arr:Array):Boolean 
		{
				var exists:Boolean = false;
				for(var i:uint=0; i < arr.length; i++) {
					if(arr[i]==word){
						exists = true;
					}
				}
				return exists;
		}
			
		/**
		 * function searchCount returns number of apperances of element in array
		 **/	
		public static function searchCount(word:Object, arr:Array):uint 
		{
				var counter:uint = 0;
				for(var i:uint=0; i < arr.length; i++) {
					if(arr[i]==word){
						counter+=1;
					}
				}
				return counter;
		}
			
		/**
		 * function iSection returns intersection array of two arrays
		 **/	
		public static function iSection(arr1:Array, arr2:Array):Array 
		{
				var arr3:Array = new Array();
				var count:uint = 0;
				for(var i:uint=0; i < arr1.length; i++){
					for(var j:uint=0; j < arr2.length; j++){
						if(arr1[i]==arr2[j]){
							arr3[count] = arr1[i];
							count+=1;
						}
					}
				}
				return arr3;
		}
			
		/**
		 * function shuffle simply shuffles given array elements
		 **/	
		public static function shuffle(b:Array):Array 
		{
				var temp:Array = new Array();
				var templen:uint;
				var take:uint;
				while (b.length > 0) {
					take = Math.floor(Math.random()*b.length);
					templen = temp.push(b[take]);
					b.splice(take,1);
				}
				return temp;
		}
			
		/**
		 * function combine returns union of two arrays
		 **/
		public static function combine(ar1:Array, ar2:Array):Array 
		{
			var rAr:Array = new Array();
			var i:uint = 0;
			var j:uint = 0;
			while((i < ar1.length) || (j < ar2.length)) {
				if(i < ar1.length){
					rAr.push(ar1[i]);
					i+=1;
				}
				if(j < ar2.length){
					rAr.push(ar2[j]);
					j+=1;
				}
			}
			return rAr;
		}
		
		/**
		 * function putLastItemOfArrayAtBeginning puts the last item of an array at the beginning of a new returned array
		 **/
		public static function putLastItemOfArrayAtBeginning(array:Array):Array
		{
			array.unshift(array[array.length-1]);
			array.pop();
			return array;
		}
		
		/**
		 * function checkIfArraysMatch returns a boolean if both arrays are the same.
		 **/
		public static function checkIfArraysMatch(arrayA:Array, arrayB:Array):Boolean 
		{
			var isMatch:Boolean = true;
			if(arrayA.length == arrayB.length) {
				for (var i:int = 0; i<arrayA.length; i++) {
					if (arrayA[i] != arrayB[i]) {
						isMatch = false;
						break;
					}
				}
			} else {
				isMatch = false;
			}
			return isMatch;
		}
		
		/**
		 * function randomizeArray returns the same array but shuffled.
		 **/
		public static function randomizeArray(array:Array):Array
		{
			var newArray:Array = new Array();
			while(array.length > 0){
				newArray.push(array.splice(Math.floor(Math.random()*array.length), 1));
			}
			return newArray;
		}
		
		/**
		 * function removeDuplicate returns an array without duplicate values.
		 **/
		public static function removeDuplicate(arr:Array):Array
		{
		    var i:int;
		    var j: int;
		    for (i = 0; i < arr.length - 1; i++){
		        for (j = i + 1; j < arr.length; j++){
		            if (arr[i] === arr[j]){
		                arr.splice(j, 1);
		            }
		        }
		    }
		    return arr;
		}
	}
}