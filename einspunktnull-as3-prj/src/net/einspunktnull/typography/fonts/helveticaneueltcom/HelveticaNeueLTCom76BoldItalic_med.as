package net.einspunktnull.typography.fonts.helveticaneueltcom 
{

	/**
	 * @author Albrecht Nitsche
	 */
	public class HelveticaNeueLTCom76BoldItalic_med
	{

		[Embed(source="HelveticaNeueLTCom-BdIt.ttf", fontWeight="bold", fontStyle="italic", fontName="HelveticaNeueLTCom", unicodeRange="U+0020-U+00FF",mimeType="application/x-font-truetype")]
		private const helveticaNeueLTCom76BoldItalic_med : String;
		public static const FONTNAME : String = "HelveticaNeueLTCom";

		private static const ERROR_MESSAGE : String = "Error - " + "Instantiation failed. This is a Singleton";
		private static const INSTANCE : HelveticaNeueLTCom76BoldItalic_med = new HelveticaNeueLTCom76BoldItalic_med(InstanceLock);

		public function HelveticaNeueLTCom76BoldItalic_med(key : Class) : void 
		{
			if (key != HelveticaNeueLTCom76BoldItalic_med) throw new Error(ERROR_MESSAGE);
		}

		public static function get register() : HelveticaNeueLTCom76BoldItalic_med 
		{
			return INSTANCE;
		}	
	}
}

internal class InstanceLock 
{
}