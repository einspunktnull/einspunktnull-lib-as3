package net.einspunktnull.utils
{
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Albrecht Nitsche
	 */
	public function objName(obj : *) : String
	{
		if (obj is String) return obj as String;
		else if (obj)
		{
			var str : String = getQualifiedClassName(obj);
			var ind : int = str.indexOf("::");
			var st : String = obj is Class ? "*" : "";
			str = st + str.substring(ind >= 0 ? (ind + 2) : 0) + st;
			str = str.replace(/</g, "&lt;").replace(/\>/g, "&gt;").replace(/\x00/g, "");
			return str;
		}
		return "---";
	}
}
