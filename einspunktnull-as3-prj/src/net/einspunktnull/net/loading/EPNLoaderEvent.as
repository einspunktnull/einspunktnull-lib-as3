package net.einspunktnull.net.loading
{
	import flash.events.Event;

	/**
	 * @author Albrecht Nitsche
	 */
	public class EPNLoaderEvent extends Event
	{
		public static const COMPLETE : String = "COMPLETE";
		public static const PROGRESS : String = "PROGRESS";
		public static const IO_ERROR : String = "IO_ERROR";
		public static const SECURITY_ERROR : String = "SECURITY_ERROR";
		
		private var _data : Object;

		public function EPNLoaderEvent(type : String, data : Object)
		{
			super(type);
			_data = data;
		}

		override public function clone() : Event
		{
			return new EPNLoaderEvent(type, data);
		}

		public function get data() : Object
		{
			return _data;
		}


	}
}
