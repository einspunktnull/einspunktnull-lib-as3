package net.einspunktnull.typography.fonts.helveticaneueltcom 
{
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Albrecht Nitsche
	 */
	dynamic public class HelveticaNeueLTCom55Roman_max 
	{
		[Embed(source="HelveticaNeueLTCom-Roman.ttf", fontName="HelveticaNeueLTCom", mimeType="application/x-font-truetype")]
		private const helveticaNeueLTCom55Roman_max : String;
		public static const FONTNAME:String = "HelveticaNeueLTCom";
		
		private static const ERROR_MESSAGE : String = "Error - " + "Instantiation failed. This is a Singleton";
		private static const INSTANCE : HelveticaNeueLTCom55Roman_max = new HelveticaNeueLTCom55Roman_max(InstanceLock);

		public function HelveticaNeueLTCom55Roman_max(key : Class) : void 
		{
			if (key != HelveticaNeueLTCom55Roman_max) throw new Error(ERROR_MESSAGE);
		}

		public static function get register() : HelveticaNeueLTCom55Roman_max 
		{
			return INSTANCE;
		}	
	}
}

internal class InstanceLock 
{
}