package net.einspunktnull.typography.fonts.helveticaneueltcom 
{

	/**
	 * @author Albrecht Nitsche
	 */
	public class HelveticaNeueLTCom55Roman_med
	{
	
		[Embed(source="HelveticaNeueLTCom-Roman.ttf", fontName="HelveticaNeueLTCom" ,unicodeRange="U+0020-U+00FF", mimeType="application/x-font-truetype")]
		private const helveticaNeueLTCom56Italic_med : String;
		public static const FONTNAME:String = "HelveticaNeueLTCom";
		
		private static const ERROR_MESSAGE : String = "Error - " + "Instantiation failed. This is a Singleton";
		private static const INSTANCE : HelveticaNeueLTCom55Roman_med = new HelveticaNeueLTCom55Roman_med(InstanceLock);

		public function HelveticaNeueLTCom55Roman_med(key : Class) : void 
		{
			if (key != HelveticaNeueLTCom55Roman_med) throw new Error(ERROR_MESSAGE);
		}

		public static function get register() : HelveticaNeueLTCom55Roman_med 
		{
			return INSTANCE;
		}	
	}
}

internal class InstanceLock 
{
}