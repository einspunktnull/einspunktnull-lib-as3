package net.einspunktnull.audio.play
{
	import flash.events.Event;

	/**
	 * @author Albrecht Nitsche
	 */
	public class SoundPlayerEvent extends Event
	{
		public static const PLAY : String = "PLAY";
		public static const PAUSE : String = "PAUSE";
		public static const STOP : String = "STOP";
		public function SoundPlayerEvent(type : String)
		{
			super(type);
		}
		
		override public function clone() : Event
		{
			return new SoundPlayerEvent(type);
		}
	}
}
