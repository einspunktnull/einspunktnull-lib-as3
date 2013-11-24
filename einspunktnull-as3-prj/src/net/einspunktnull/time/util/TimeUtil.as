package net.einspunktnull.time.util
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author Albrecht Nitsche
	 */
	public class TimeUtil
	{
		public static function callByDelay(delay : Number, callback : Function, callBackParams : Array = null) : void
		{
			var timer : Timer = new Timer(delay * 1000, 1);

			var onTimerComplete : Function = function(callback : Function, callBackParams : Array = null) : void
			{
				if (callBackParams != null) callback.apply(callback, callBackParams);
				else callback.apply(callback);
			};

			timer.addEventListener(TimerEvent.TIMER_COMPLETE, function() : void
			{
				if (callback != null)
				{
					if (callBackParams != null) onTimerComplete(callback, callBackParams);
					else onTimerComplete(callback);
				}
			});
			timer.start();
		}

		public static function currentTimeMillis() : Number
		{
			return new Date().milliseconds;
		}
	}
}
