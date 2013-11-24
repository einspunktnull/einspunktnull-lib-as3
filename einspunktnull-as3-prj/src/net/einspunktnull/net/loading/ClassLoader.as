package net.einspunktnull.net.loading
{
	import flash.errors.IllegalOperationError;

	/**
	 * @author Albrecht Nitsche
	 */
	public class ClassLoader extends SWFLoader implements IEPNLoader
	{
		private var _className : String;
		public function ClassLoader(url : String = null, className : String = null)
		{
			_className = className;
			super(url);
		}

		public function getClass(className : String) : Class
		{
			try
			{
				return _loader.contentLoaderInfo.applicationDomain.getDefinition(className)  as  Class;
			}
			catch (e : Error)
			{
				throw new IllegalOperationError(className + " definition not found in " + _url);
			}
			return null;
		}

		override public function get content() : *
		{
			return getClass(_className);
		}

	}
}
