package net.einspunktnull.typography.fonts.helveticaneueltcom 
{

	/**
	 * @author Albrecht Nitsche
	 */
	public class HelveticaNeueLTCom75Bold_max 
	{

		[Embed(source="HelveticaNeueLTCom-Bd.ttf", fontWeight="bold", fontName="HelveticaNeueLTCom", mimeType="application/x-font-truetype")]
		private const helveticaNeueLTCom75Bold_max : String;
		public static const FONTNAME : String = "HelveticaNeueLTCom";

		private static const ERROR_MESSAGE : String = "Error - " + "Instantiation failed. This is a Singleton";
		private static const INSTANCE : HelveticaNeueLTCom75Bold_max = new HelveticaNeueLTCom75Bold_max(InstanceLock);

		public function HelveticaNeueLTCom75Bold_max(key : Class) : void 
		{
			if (key != HelveticaNeueLTCom75Bold_max) throw new Error(ERROR_MESSAGE);
		}

		public static function get register() : HelveticaNeueLTCom75Bold_max 
		{
			return INSTANCE;
		}
	}
}

internal class InstanceLock 
{
}