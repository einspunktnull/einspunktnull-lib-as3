package net.einspunktnull.data.util
{
	/**
	 * @author Albrecht Nitsche
	 */
	public class ArrayUtil
	{
		/**
		 * @return returns the Array cleared
		 */
		public static function clear(array : Array) : Array
		{
			while (array.length > 0) array.pop();
			return array;
		}

		public static function duplicate(inArray : Array) : Array
		{
			var cloneArray : Array = new Array();
			for each (var obj : Object in inArray)
			{
				cloneArray.push(obj);
			}
			return cloneArray;
		}


		public static function contains(inArr : Array, searchObject : Object) : Boolean
		{
			return inArr.indexOf(searchObject) > -1;
		}

		/**
		 * @return returns an Array of found Objects
		 */
		public static function getElementsByProperty(inArr : Array, propertyName : String, propertyValue : *) : Array
		{
			var resultArr : Array = new Array();
			var propertyArr : Array = propertyName.split(".");


			for each (var obj : Object in inArr)
			{
				var tmpObj : Object = obj;
				for each (var prop : String in propertyArr)
				{
					if (tmpObj.hasOwnProperty(prop)) tmpObj = tmpObj[prop];
				}
				if (tmpObj == propertyValue) resultArr.push(obj);
			}
			return resultArr;
		}

		/**
		 * @return returns an Array of found Objects
		 */
		public static function getElementsByType(inArr : Array, type : Class) : Array
		{
			var resultArr : Array = new Array();
			for each (var i : Object in inArr)
			{
				if (i is type) resultArr.push(i);
			}
			return resultArr;
		}

		public static function randomize(array : Array) : Array
		{
			if (array == null || array.length < 0) return array;
			else
			{
				var indexArr : Array = new Array();
				var valid : Boolean;
				var index : uint = Math.floor(Math.random() * array.length);
				indexArr.push(index);

				for (var i : uint = 1;i < array.length;i++)
				{
					valid = false;
					while (!valid)
					{
						index = Math.floor(Math.random() * array.length);
						valid = true;

						for (var x : uint = 0;x < indexArr.length;x++)
						{
							if (index == indexArr[x])
							{
								valid = false;
								break;
							}
						}
					}
					indexArr.push(index);
				}

				var newArr : Array = new Array();
				for each (var pos:uint in indexArr) newArr.push(array[pos]);

				return newArr;
			}
		}

		/**
		 * @return An array of all members of 'a' that are not members of 'b'.
		 */
		public static function setDifference(a : Array, b : Array) : Array
		{
			var setArr : Array = duplicate(a);
			for each (var obj : Object in b)
			{
				if (contains(setArr, obj))
				{
					setArr.splice(setArr.indexOf(obj), 1);
				}
			}
			return setArr;
		}

		/**
		 * @return An array of all objects that are a member of exactly one of A and B (elements, which are in one of both, bout not in both).
		 */
		public static function setSymmetricDifference(a : Array, b : Array) : Array
		{
			var setArr : Array = new Array();
			for each (var objA : Object in a)
			{
				if ( !contains(b, objA)) setArr.push(objA);
			}
			for each (var objB : Object in b)
			{
				if ( !contains(a, objB)) setArr.push(objB);
			}
			return setArr;
		}

		/**
		 * @return An Array of all objects that are a member of A, or B, or both.
		 */
		public static function setUnion(a : Array, b : Array) : Array
		{
			var setArr : Array = duplicate(a);
			for each (var objB : Object in b)
			{
				if ( !contains(a, objB)) setArr.push(objB);
			}

			return setArr;
		}

		/**
		 * @return An Array of all objects that are members of both A and B.
		 */
		public static function setIntersection(a : Array, b : Array) : Array
		{
			var setArr : Array = new Array();
			for each (var objA : Object in a)
			{

				if ( contains(b, objA)) setArr.push(objA);
			}
			return setArr;
		}

		public static function distinct(array : Array) : Array
		{
			if (!array) return null;
			var ret : Array = new Array();
			for each (var string : String in array)
			{
				if (!contains(ret, string)) ret.push(string);
			}
			return ret;
		}

		/**
		 * Adds an value, only if it doesn't already exists in Array
		 */
		public static function pushDistinct(arr : Array, obj : Object) : void
		{
			if (!contains(arr, obj)) arr.push(obj);
		}


	}
}
