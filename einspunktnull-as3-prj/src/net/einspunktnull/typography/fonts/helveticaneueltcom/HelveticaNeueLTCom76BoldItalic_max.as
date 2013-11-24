package net.einspunktnull.typography.fonts.helveticaneueltcom 
{

	/**
	 * @author Albrecht Nitsche
	 */
	public class HelveticaNeueLTCom76BoldItalic_max 
	{

		[Embed(source="HelveticaNeueLTCom-BdIt.ttf", fontWeight="bold", fontStyle="italic", fontName="HelveticaNeueLTCom", mimeType="application/x-font-truetype")]
		private const helveticaNeueLTCom76BoldItalic_max : String;
		public static const FONTNAME : String = "HelveticaNeueLTCom";

		private static const ERROR_MESSAGE : String = "Error - " + "Instantiation failed. This is a Singleton";
		private static const INSTANCE : HelveticaNeueLTCom76BoldItalic_max = new HelveticaNeueLTCom76BoldItalic_max(InstanceLock);

		public function HelveticaNeueLTCom76BoldItalic_max(key : Class) : void 
		{
			if (key != HelveticaNeueLTCom76BoldItalic_max) throw new Error(ERROR_MESSAGE);
		}

		public static function get register() : HelveticaNeueLTCom76BoldItalic_max 
		{
			return INSTANCE;
		}
	}
}

internal class InstanceLock 
{
}