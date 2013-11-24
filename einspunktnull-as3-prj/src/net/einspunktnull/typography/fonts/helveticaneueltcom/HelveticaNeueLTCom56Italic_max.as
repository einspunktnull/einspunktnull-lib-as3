package net.einspunktnull.typography.fonts.helveticaneueltcom 
{

	/**
	 * @author Albrecht Nitsche
	 */
	public class HelveticaNeueLTCom56Italic_max
	{

		[Embed(source="HelveticaNeueLTCom-It.ttf", fontStyle="italic",fontName="HelveticaNeueLTCom", mimeType="application/x-font-truetype")]
		private const helveticaNeueLTCom56Italic_max : String;
		public static const FONTNAME : String = "HelveticaNeueLTCom";

		private static const ERROR_MESSAGE : String = "Error - " + "Instantiation failed. This is a Singleton";
		private static const INSTANCE : HelveticaNeueLTCom56Italic_max = new HelveticaNeueLTCom56Italic_max(InstanceLock);

		public function HelveticaNeueLTCom56Italic_max(key : Class) : void 
		{
			if (key != HelveticaNeueLTCom56Italic_max) throw new Error(ERROR_MESSAGE);
		}

		public static function get register() : HelveticaNeueLTCom56Italic_max 
		{
			return INSTANCE;
		}	
	}
}

internal class InstanceLock 
{
}