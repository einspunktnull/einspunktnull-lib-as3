package net.einspunktnull.io.autocompletion
{
	import flash.events.Event;

	/**
	 * @author Albrecht Nitsche
	 */
	public class AutoCompletionEvent extends Event
	{
		public static const COMPLETIONS : String = "COMPLETIONS";
		private var _completions : Array;

		public function AutoCompletionEvent(type : String, completions : Array)
		{
			super(type);
			_completions = completions;
		}

		public function get completions() : Array
		{
			return _completions;
		}

		override public function clone() : Event
		{
			return new AutoCompletionEvent(type, completions);
		}

	}
}
