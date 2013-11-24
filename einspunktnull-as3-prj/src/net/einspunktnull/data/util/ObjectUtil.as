package net.einspunktnull.data.util 
{
	import net.einspunktnull.utils.getClassDefinition;

	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Albrecht Nitsche
	 */
	public class ObjectUtil 
	{

		public static function copyData(source : Object, target : Object) : void 
		{
			//copies data from commonly named properties and getter/setter pairs
			if(source && target && target is getClassDefinition(source) ) 
			{
				try 
				{
					var sourceInfo : XML = describeType(source);
					
					var prop : XML;
 
					for each(prop in sourceInfo.variable) 
					{
						if(target.hasOwnProperty(prop.@name)) 
						{
							target[prop.@name] = source[prop.@name];
						}
					}
 
					for each(prop in sourceInfo.accessor) 
					{
						if(prop.@access == "readwrite" && prop.@access == "readwrite") 
						{
							if(target.hasOwnProperty(prop.@name)) 
							{
								target[prop.@name] = source[prop.@name];
							}
						}
					}
				}
             	catch (err : Object) 
				{
					trace(err);
				}
			}
		}

		public static function newSibling(sourceObj : Object) : * 
		{
			if(sourceObj) 
			{
				var objSibling : *;
				try 
				{
					var classOfSourceObj : Class = getDefinitionByName(getQualifiedClassName(sourceObj)) as Class;
					objSibling = new classOfSourceObj();
				}
             	catch(e : Object) 
				{
				}
				return objSibling;
			}
			return null;
		}

		public static function clone(source : Object) : Object 
		{
			var clone : Object;
			if(source) 
			{
				clone = newSibling(source);
 
				if(clone) 
				{
					copyData(source, clone);
				}
			}
			return clone;
		}

		
		
		public static function copyProperty(source : Object,target : Object,propertyName : String) : void
		{
			if(source.hasOwnProperty(propertyName))
			{
				if(target.hasOwnProperty(propertyName))
				{
					target[propertyName] = source[propertyName];
				}
				else
				{
					trace("targetObject has no property named '" + propertyName + "'");
				}
			}
			else
			{
				trace("sourceObject has no property named '" + propertyName + "'");
			}
		}
	}
}
