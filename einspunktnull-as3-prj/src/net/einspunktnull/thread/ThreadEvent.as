package net.einspunktnull.thread
{
	import flash.events.Event;

	/**
	 * @author Albrecht Nitsche
	 */
	public class ThreadEvent extends Event
	{
		public static const ERROR : String = "error";
		public static const COMPLETE : String = "complete";
		public static const PROGRESS : String = "progress";
		private var _msg : String;
		private var _data : *;

		public function ThreadEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false, msg : String = "", data : *=null)
		{
			super(type, bubbles, cancelable);
			_msg = msg;
			_data = data;
		}


		override public function clone() : Event
		{
			return new ThreadEvent(type, bubbles, cancelable, msg, data);
		}

		public function get msg() : String
		{
			return _msg;
		}

		public function get data() : *
		{
			return _data;
		}
	}
}
