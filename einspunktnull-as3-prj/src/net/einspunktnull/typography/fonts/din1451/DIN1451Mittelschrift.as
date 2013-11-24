package net.einspunktnull.typography.fonts.din1451
{

	/**
	 * @author Albrecht Nitsche
	 */
	dynamic public class DIN1451Mittelschrift
	{
		[Embed(source="../assets/DIN1451Mittelschrift.ttf", fontFamily="DIN1451Mittelschrift")]
		private var dinN1451Mittelschrift : String;
		public static const FONTFAMILY : String = "DIN1451Mittelschrift";
		private static const ERROR_MESSAGE : String = "Error - " + "Instantiation failed. This is a Singleton";
		private static const INSTANCE : DIN1451Mittelschrift = new DIN1451Mittelschrift(InstanceLock);

		public function DIN1451Mittelschrift(key : Class) : void
		{
			if (key != DIN1451Mittelschrift) throw new Error(ERROR_MESSAGE);
		}

		public static function get register() : DIN1451Mittelschrift
		{
			return INSTANCE;
		}
	}
}
internal class InstanceLock
{
}