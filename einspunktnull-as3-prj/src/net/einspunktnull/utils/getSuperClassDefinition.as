package net.einspunktnull.utils
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedSuperclassName;

	/**
	 * @author Albrecht Nitsche
	 */
	public function getSuperClassDefinition(obj : Object) : Class
	{
		var name : String = getQualifiedSuperclassName(obj);
		if (!name) return null;
		return Class(getDefinitionByName(name));
	}
}
