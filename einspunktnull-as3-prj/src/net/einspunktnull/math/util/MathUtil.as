package net.einspunktnull.math.util
{
	/**
	 * @author Albrecht Nitsche
	 */
	public class MathUtil
	{

		public static function rad2deg(radAngle : Number) : Number
		{
			return radAngle * 180 / Math.PI;
		}

		public static function deg2rad(degAngle : Number) : Number
		{
			return degAngle * Math.PI / 180;
		}

		public static function cotan(radAngle : Number) : Number
		{
			return Math.cos(radAngle) / Math.sin(radAngle);
		}

		public static function atan3(y : Number, x : Number) : Number
		{
			var angle : Number = Math.atan2(y, x);
			if (angle < 0) angle += 2 * Math.PI;
			return angle;
		}

		public static function quadraticRoots(a : Number, b : Number, c : Number) : Array
		{
			var results : Array = new Array();
			var sqt : Number = Math.sqrt(Math.pow(b, 2) - 4 * a * c);
			var root1 : Number = (b + sqt) / (2 * a);
			var root2 : Number = (b - sqt) / (2 * a);
			if (!isNaN(root1))
			{
				results.push(root1);
			}
			if (!isNaN(root2))
			{
				results.push(root2);
			}
			return results;
		}

		public static function distance(obj1 : Object, obj2 : Object) : Number
		{
			var dx : Number = obj1["x"] - obj2["x"];
			var dy : Number = obj1["y"] - obj2["y"];
			return Math.sqrt(dx * dx + dy * dy);
		}

		public static function map(value : Number, minSrc : Number, maxSrc : Number, minTarget : Number = 0, maxTarget : Number = 1) : Number
		{
			return (value == minSrc) ? minTarget : (value - minSrc) * (maxTarget - minTarget) / (maxSrc - minSrc) + minTarget;
		}

		public static function isEven(number : Number) : Boolean
		{
			return number % 2 == 0;
		}

		public static function numberEquals(number1 : Number, number2 : Number, toleranceRange : Number = 0.1) : Boolean
		{
			var diff : Number = Math.abs(number1 - number2);
			return diff <= toleranceRange;
		}

		// ggT
		public static function gcd(a : int, b : int) : int
		{
			var tmp : int;

			while (b > 0)
			{
				if (b > a)
				{
					tmp = a;
					a = b;
					b = tmp;
				}
				a = a - b;
			}
			return a;
		}

		public static function randomInt(min : int, max : int) : int
		{
			var range : int = max - min;
			return int(Math.round(Math.random() * range) + min);
		}


	}
}
