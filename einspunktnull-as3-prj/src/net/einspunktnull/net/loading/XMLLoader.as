package net.einspunktnull.net.loading
{

	/**
	 * @author Albrecht Nitsche
	 */
	public class XMLLoader extends TextLoader implements IEPNLoader
	{

		public function XMLLoader(url : String = null)
		{
			super(url);
			XML.ignoreWhitespace = true;
			XML.ignoreComments = true;
		}

		public function getXML() : XML
		{
			return new XML(super.getText());
		}

		override public function get content() : *
		{
			return getXML();
		}

	}
}
