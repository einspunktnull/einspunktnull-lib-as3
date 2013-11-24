package net.einspunktnull.net.loading
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	/**
	 * @author Albrecht Nitsche
	 */
	public class SWFLoader extends EPNLoader implements IEPNLoader
	{
		protected var _loader : Loader;

		public function SWFLoader(url : String = null)
		{
			_loader = new Loader();
			super(_loader.contentLoaderInfo, url);
		}

		public function load(url : String = null) : void
		{
			if (url) _url = url;
			var context : LoaderContext = new LoaderContext();
			context.applicationDomain = ApplicationDomain.currentDomain;
			addListeners();
			_loader.load(new URLRequest(_url), context);
		}

		public function getSwf() : DisplayObject
		{
			return _loader.content;
		}

		public function get content() : *
		{
			return getSwf();
		}
	}
}
