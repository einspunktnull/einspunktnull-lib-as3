package net.einspunktnull.net.loading
{
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	/**
	 * @author Albrecht Nitsche
	 */
	public class TextLoader extends EPNLoader implements IEPNLoader
	{
		private var _loader : URLLoader;

		public function TextLoader(url : String = null)
		{
			if (url) _url = url;
			_loader = new URLLoader();
			_loader.dataFormat = URLLoaderDataFormat.TEXT;
			super(_loader, url);
		}

		public function load(url : String = null) : void
		{
			if (url) _url = url;
			addListeners();
			var urlRequest:URLRequest = new URLRequest(_url);
			urlRequest.data = vars;
			_loader.load(urlRequest);
		}

		public function getText() : String
		{
			return _loader.data as String;
		}

		public function get content() : *
		{
			return getText();
		}
	}
}
