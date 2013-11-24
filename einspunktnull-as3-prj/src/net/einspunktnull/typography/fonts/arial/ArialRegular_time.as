package net.einspunktnull.typography.fonts.arial
{

	/**
	 * @author Albrecht Nitsche
	 */
	dynamic public class ArialRegular_time 
	{
		[Embed(source="arial.ttf", fontName="Arial", unicodeRange="U+0030-U+003A", mimeType="application/x-font-truetype")]
		private const arialRegular_math : String;
		public static const FONTNAME:String = "Arial";
		
		private static const ERROR_MESSAGE : String = "Error - " + "Instantiation failed. This is a Singleton";
		private static const INSTANCE : ArialRegular_time = new ArialRegular_time(InstanceLock);

		public function ArialRegular_time(key : Class) : void 
		{
			if (key != ArialRegular_time) throw new Error(ERROR_MESSAGE);
		}

		public static function get register() : ArialRegular_time 
		{
			return INSTANCE;
		}	
	}
}

internal class InstanceLock 
{
}