package net.einspunktnull.data.util
{
	/**
	 * @author Albrecht Nitsche
	 */
	public class ConvertUtil
	{
		public static function uintDec2StringHex(dec : uint) : String
		{
			var digits : String = "0123456789abcdef";
			var hex : String = "";
			while (dec > 0)
			{
				var next : uint = dec & 0xF;
				dec >>= 4;
				hex = digits.charAt(next) + hex;
			}
			if (hex.length == 0) hex = "000000";
			return "0x" + hex;
		}

		public static function stringHex2UintDec(hex : String) : uint
		{
			var digits : String = "0123456789abcdef";
			var dec : uint = 0;
			if (hex.indexOf("0x") >= 0)
			{
				if (hex.indexOf("0x") == 0)
				{
					hex = hex.substr(2, hex.length - 2);
				}
				else if (hex.indexOf("0x") > 0)
				{
					return dec;
				}
			}
			if (hex.search(/[^0-9a-f]/g) >= 0) return dec;
			var len : uint = hex.length;
			for (var i : int = len - 1; i > -1; i--)
			{
				var char : String = hex.charAt(i);
				var factor : uint = digits.indexOf(char);
				var pot : uint = len - i - 1;
				var base : uint = 16;
				dec += factor * Math.pow(base, pot);
			}
			return dec;
		}

		public static function argb2uintArray(argb : uint) : Array
		{
			var tmpArr : Array = [];
			var argbArr : Array = [];
			var base : uint = 16;
			while (argb > 0)
			{
				var rest : uint = argb % base;
				argb /= base;
				tmpArr.push(rest);
			}
			tmpArr = tmpArr.reverse();

			if (tmpArr.length % 2 != 0) return argbArr;
			for (var i : int = 0; i < tmpArr.length; i += 2)
			{
				var val1 : uint = tmpArr[i] * Math.pow(base, 1);
				var val2 : uint = tmpArr[i];
				argbArr.push(val1 + val2);
			}
			return argbArr;
		}

		public static function bytesToKibiBytes(bytes : Number) : Number
		{
			return bytes / 1024;
		}

		public static function bytesToMebiBytes(bytes : Number) : Number
		{
			return bytesToKibiBytes(bytes) / 1024;
		}

		public static function bytesToGibiBytes(bytes : Number) : Number
		{
			return bytesToMebiBytes(bytes) / 1024;
		}

		public static function filesize(bytes : Number, dec : uint = 2) : String
		{

			var depth : uint = 0;
			var depthArr : Array = ["Bytes", "KiB", "MiB", "GiB", "TiB"];

			var curBytesAsString : String = String(Math.floor(bytes));

			while (curBytesAsString.length > 3)
			{
				bytes /= 1024;
				curBytesAsString = String(Math.floor(bytes));
				depth++;
			}

			return bytes.toFixed(dec) + " " + depthArr[depth];
		}


	}
}
