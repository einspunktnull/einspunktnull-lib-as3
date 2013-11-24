package net.einspunktnull.net.loading
{

	import flash.net.URLRequest;

	import deng.fzip.FZip;

	/**
	 * @author Albrecht Nitsche
	 */
	public class ZIPLoader extends EPNLoader implements IEPNLoader
	{
		private var _zip : FZip;

		public function ZIPLoader(url : String = null)
		{
			_url = url;
			_zip = new FZip();
			super(_zip, url);
		}

		public function load(url : String = null) : void
		{
			if (url) _url = url;
			addListeners();
			_zip.load(new URLRequest(_url));
		}

		public function getZip() : FZip
		{
			return _zip;
		}

		public function get content() : *
		{
			return getZip();
		}
	}
}
