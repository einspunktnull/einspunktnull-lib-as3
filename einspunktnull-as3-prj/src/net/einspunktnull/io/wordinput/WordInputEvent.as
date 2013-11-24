package net.einspunktnull.io.wordinput
{
	import flash.events.Event;

	/**
	 * @author Albrecht Nitsche
	 */
	public class WordInputEvent extends Event
	{
		public static const MATCH : String = "MATCH";
		public static const OBSERVE : String = "OBSERVE";
		public static const IGNORE : String = "IGNORE";
		private var _input : WordInput;

		public function WordInputEvent(type : String, input : WordInput)
		{
			super(type);
			_input = input;
		}

		public function get input() : WordInput
		{
			return _input;
		}


		override public function clone() : Event
		{
			return new WordInputEvent(type, input);
		}
	}
}
