package net.einspunktnull.utils
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Albrecht Nitsche
	 */
	public function getClassDefinition(obj : Object) : Class
	{
		var ret : Object = getDefinitionByName(getQualifiedClassName(obj));
		if (ret is Class) return ret as Class;
		return null;
	}
}
