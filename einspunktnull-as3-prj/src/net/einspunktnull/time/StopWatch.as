package net.einspunktnull.time
{
	import flash.utils.getTimer;
	import flash.events.EventDispatcher;

	/**
	 * @author Albrecht Nitsche
	 */
	public class StopWatch extends EventDispatcher
	{
		private static var _instance : StopWatch;
		private var _startTime : int;
		private var _endTime : int;
		private var _elapsedTime : int;

		public function StopWatch(key : Key)
		{
		}

		private static function get instance() : StopWatch
		{
			if (_instance == null) _instance = new StopWatch(new Key());
			return _instance;
		}

		public static function start() : void
		{
			instance._startTime = getTimer();
		}

		public static function stop() : void
		{
			instance._endTime = getTimer();
			instance._elapsedTime = instance._endTime - instance._startTime;
		}

		public static function get elapsedTime() : int
		{
			return instance._elapsedTime;
		}
	}
}
internal class Key
{
}
