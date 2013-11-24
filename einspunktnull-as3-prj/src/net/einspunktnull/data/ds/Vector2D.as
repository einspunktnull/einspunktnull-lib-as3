package net.einspunktnull.data.ds
{
	/**
	 * @author Albrecht Nitsche
	 */
	public class Vector2D
	{
		private var _x : Number;
		private var _y : Number;

		public function Vector2D(x : Number = 0, y : Number = 0)
		{
			_x = x;
			_y = y;
		}



		/********************************
		 * 	SINGLE
		 ********************************/

		public function clone() : Vector2D
		{
			return new Vector2D(_x, _y);
		}

		public function zero() : Vector2D
		{
			_x = 0;
			_y = 0;
			return this;
		}

		public function isZero() : Boolean
		{
			return _x == 0 && _y == 0;
		}

		public function normalize() : Vector2D
		{
			var len : Number = length;
			if (len == 0)
			{
				_x = 1.0;
				return this;
			}
			_x /= len;
			_y /= len;
			return this;
		}

		public function truncate(max : Number) : Vector2D
		{
			length = Math.min(max, length);
			return this;
		}

		public function reverse() : Vector2D
		{
			_x = -_x;
			_y = -_y;
			return this;
		}

		public function isNormalized() : Boolean
		{
			return length == 1.0;
		}



		/********************************
		 * 	RELATIONSHIP
		 ********************************/

		public static function angleBetween(v1 : Vector2D, v2 : Vector2D) : Number
		{
			if (!v1.isNormalized()) v1.clone().normalize();
			if (!v2.isNormalized()) v2.clone().normalize();
			return Math.acos(v1.dotProduct(v2));
		}

		public function dotProduct(v2 : Vector2D) : Number
		{
			return _x * v2.x + _y * v2.y;
		}

		public function sign(v2 : Vector2D) : int
		{
			return perpendicular.dotProduct(v2) < 0 ? -1 : 1;
		}

		public function distance(v2 : Vector2D) : int
		{
			return Math.sqrt(distanceSquared(v2));
		}

		public function distanceSquared(v2 : Vector2D) : Number
		{
			var dx : Number = v2.x - x;
			var dy : Number = v2.y - y;
			return dx * dx + dy * dy;
		}

		public function add(v2 : Vector2D) : Vector2D
		{
			return new Vector2D(_x + v2.x, _y + v2.y);
		}

		public function subtract(v2 : Vector2D) : Vector2D
		{
			return new Vector2D(_x - v2.x, _y - v2.y);
		}

		public function multiply(value : Number) : Vector2D
		{
			return new Vector2D(_x * value, _y * value);
		}

		public function divide(value : Number) : Vector2D
		{
			return new Vector2D(_x / value, _y / value);
		}

		public function equals(v2 : Vector2D) : Boolean
		{
			return _x == v2.x && _y == v2.y;
		}

		public function toString() : String
		{
			return "Vetor2D (x:" + _x + ", y:" + _y + ")";
		}



		/********************************
		 * 	GETTER / SETTER
		 ********************************/

		public function get perpendicular() : Vector2D
		{
			return new Vector2D(-y, x);
		}

		public function set length(length : Number) : void
		{
			var ang : Number = angle;
			_x = Math.cos(ang) * length;
			_y = Math.sin(ang) * length;
		}

		public function get length() : Number
		{
			return Math.sqrt(lengthSquared);
		}

		public function get lengthSquared() : Number
		{
			return _x * _x + _y * _y;
		}

		public function set angle(angle : Number) : void
		{
			var len : Number = length;
			_x = Math.cos(angle) * len;
			_y = Math.sin(angle) * len;
		}

		public function get angle() : Number
		{
			return Math.atan2(_y, _x);
		}


		public function get x() : Number
		{
			return _x;
		}

		public function set x(x : Number) : void
		{
			_x = x;
		}

		public function get y() : Number
		{
			return _y;
		}

		public function set y(y : Number) : void
		{
			_y = y;
		}
	}
}
