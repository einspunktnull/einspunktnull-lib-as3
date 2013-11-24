package net.einspunktnull.data.util
{
	/**
	 * @author Albrecht Nitsche
	 */
	public class StringUtil
	{
		public static function textAsBoolean(text : String) : Boolean
		{
			return text == "true";
		}

		public static function booleanAsIntegerString(boolean : Boolean) : String
		{
			return boolean ? "1" : "0";
		}

		public static function stringListAsArray(stringList : String, separator : String) : Array
		{
			if ( stringList == "") return new Array();
			return stringList.split(separator);
		}

		public static function getFileExtension(fileName : String) : String
		{
			var point : String = ".";
			if (contains(fileName, point))
			{
				var index : int = fileName.lastIndexOf(point);
				if (index == -1) return "";
				else return fileName.substr(index + 1, fileName.length);
			}
			return "";
		}

		public static function contains(text : String, regex : String) : Boolean
		{
			var regExp : RegExp = new RegExp(regex);
			return text.search(regExp) != -1;
		}

		public static function beginsWith(text : String, regex : String) : Boolean
		{
			var regExp : RegExp = new RegExp(regex);
			return text.search(regExp) == 0;
		}
	}
}
