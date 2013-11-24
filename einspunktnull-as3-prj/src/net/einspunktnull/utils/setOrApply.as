package net.einspunktnull.utils
{
	import flash.utils.getDefinitionByName;

	/**
	 * @author Albrecht Nitsche
	 */
	public function setOrApply(thisObj : *, defName : String, propOrFctName : String, ...args) : Boolean
	{
		if (hasDefinition(defName))
		{
			var obj : Object = getDefinitionByName(defName);
			if (obj is Class)
			{
				if (obj.hasOwnProperty(propOrFctName))
				{
					if ( obj[propOrFctName] is Function)
					{
						var fct1 : Function = obj[propOrFctName] as Function;
						fct1.apply(thisObj, args);
						return true;
					}
					else
					{
						obj[propOrFctName] = args[0];
						return true;
					}
					return false;
				}
			}
			else if (obj is Function)
			{
				var fct2 : Function = obj as Function;
				fct2.apply(thisObj, args);
				return true;
			}
		}

		return false;
	}
}
