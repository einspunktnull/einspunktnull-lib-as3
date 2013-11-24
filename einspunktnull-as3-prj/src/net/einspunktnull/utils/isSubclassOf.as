package net.einspunktnull.utils
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;

	/**
	 * @author Albrecht Nitsche
	 */
	public function isSubclassOf(subClass : Class, superClass : Class) : Boolean
	{
		var s : String = getQualifiedClassName(superClass);

		var b : String = getQualifiedSuperclassName(subClass);
		while (b && b != s)
		{
			b = getQualifiedSuperclassName(getDefinitionByName(b));
		}
		if (b) return true;
		return false;
	}

	/*
	 * public static function subclassOf(type:Class, superClass:Class):Boolean {
	 * try {
	 * for(var c:Class = type; c != Object; c = getDefinitionByName(getQualifiedSuperclassName(c))) {
	 * if(c == superClass) {
	 * return true;
	 * }
	 * }
	 * } catch(e:Error) {}
	 * return false;
	 * } 
	 */
}
