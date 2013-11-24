package net.einspunktnull.utils
{
	import flash.utils.getDefinitionByName;

	/**
	 * @author Albrecht Nitsche
	 */
	 
	public function hasDefinition(definitionName : String) : Boolean
	{
		try
		{
			if (getDefinitionByName(definitionName)) return true;
			else return false;
		}
		catch(error : Error)
		{
			return false;
		}
		return false;
	}
}
