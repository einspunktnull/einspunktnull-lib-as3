package net.einspunktnull.typography.fonts.helveticaneueltcom 
{

	/**
	 * @author Albrecht Nitsche
	 */
	public class HelveticaNeueLTCom56Italic_med
	{

		[Embed(source="HelveticaNeueLTCom-It.ttf", fontStyle="italic",fontName="HelveticaNeueLTCom", mimeType="application/x-font-truetype")]
		private const helveticaNeueLTCom56Italic_med : String;
		public static const FONTNAME : String = "HelveticaNeueLTCom";

		private static const ERROR_MESSAGE : String = "Error - " + "Instantiation failed. This is a Singleton";
		private static const INSTANCE : HelveticaNeueLTCom56Italic_med = new HelveticaNeueLTCom56Italic_med(InstanceLock);

		public function HelveticaNeueLTCom56Italic_med(key : Class) : void 
		{
			if (key != HelveticaNeueLTCom56Italic_med) throw new Error(ERROR_MESSAGE);
		}

		public static function get register() : HelveticaNeueLTCom56Italic_med 
		{
			return INSTANCE;
		}	
	}
}

internal class InstanceLock 
{
}