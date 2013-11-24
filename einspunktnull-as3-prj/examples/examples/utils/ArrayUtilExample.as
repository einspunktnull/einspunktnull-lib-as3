package
examples.utils{
	import net.einspunktnull.data.util.ArrayUtil;

	import flash.display.Sprite;

	/**
	 * @author Albrecht Nitsche
	 */
	public class ArrayUtilExample extends Sprite
	{
		public function ArrayUtilExample()
		{
			/*
			 * Clear an Array
			 */
			var array : Array = [1, 2, 3];
			trace("full array:", array);
			ArrayUtil.clear(array);
			trace("empty array:", array);

			/*
			 * find objects
			 */
			var array2 : Array = [1, 2, 3, {name:"axel"}, new String("pimmmel"), {name:"peter"}];
			var results : Array = ArrayUtil.getElementsByProperty(array2, "name", "axel");
			trace("results", results);
			var results2 : Array = ArrayUtil.getElementsByType(array2, int);
			trace("results2", results2);

			/*
			 * remove Duplicates
			 */
			var duplicateValuesArr : Array = [1, 2, 3, "Pimmel", 2, 3, 2, 4, new String("pimmmel"), {name:"peter"}];
			var distinctValuesArr : Array = ArrayUtil.distinct(duplicateValuesArr);
			trace("distinctValuesArr", distinctValuesArr);


			/*
			 * Duplicate an Array
			 */
			var arrayOrig : Array = [1, 2, 3];
			var arrayDuplicate : Array = ArrayUtil.duplicate(arrayOrig);
			trace("duplicated array:", arrayDuplicate);

			/*
			 * set theory - set difference - An array of all members of 'a' that are not members of 'b'.
			 */
			var arrayA1 : Array = [1, 2, 3];
			var arrayB1 : Array = [2, 3, 4];
			var resultSetDiff : Array = ArrayUtil.setDifference(arrayA1, arrayB1);
			trace("set theory - set difference:", resultSetDiff);

			/*
			 * set theory - symetric difference - An array of all objects that are a member of exactly one of A and B
			 * (elements , which are in one of both, bout not in both).
			 */

			var arrayA2 : Array = [1, 2, 3];
			var arrayB2 : Array = [2, 3, 4];
			var resultSetSymDiff : Array = ArrayUtil.setSymmetricDifference(arrayA2, arrayB2);
			trace("set theory - set symetric difference:", resultSetSymDiff);

			/*
			 * set theory - union - Array of all objects that are a member of A, or B, or both.
			 */
			var arrayA3 : Array = [1, 2, 3];
			var arrayB3 : Array = [2, 3, 4];
			var resultSetUnion : Array = ArrayUtil.setUnion(arrayA3, arrayB3);
			trace("set theory - union:", resultSetUnion);

			/*
			 * set theory - intersection - Array of all objects that are members of both A and B.
			 */
			var arrayA4 : Array = [1, 2, 3];
			var arrayB4 : Array = [2, 3, 4];
			var resultSetIntersection : Array = ArrayUtil.setIntersection(arrayA4, arrayB4);
			trace("set theory - intersection:", resultSetIntersection);
		}

	}
}
