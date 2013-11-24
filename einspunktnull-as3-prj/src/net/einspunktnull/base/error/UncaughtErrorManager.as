package net.einspunktnull.base.error
{
	import flash.display.LoaderInfo;
	import flash.events.ErrorEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.utils.Dictionary;

	/**
	 * @author Albrecht Nitsche
	 */
	public class UncaughtErrorManager
	{
		private static var _instance : UncaughtErrorManager;
		private var _callbacks : Dictionary = new Dictionary();

		public function UncaughtErrorManager(key : Class)
		{
		}

		private static function get instance() : UncaughtErrorManager
		{
			if (_instance == null) _instance = new UncaughtErrorManager(Key);
			return _instance;
		}

		public static function add(loaderInfo : LoaderInfo, callback : Function = null) : Boolean
		{
			if (instance._callbacks[loaderInfo]) return false;
			var theCallback : Function = callback != null ? callback : instance.defaultUncaughtErrorEventHandler;
			loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, theCallback);
			instance._callbacks[loaderInfo] = theCallback;
			return true;
		}

		public static function remove(loaderInfo : LoaderInfo, callback : Function = null) : Boolean
		{
			if (!instance._callbacks[loaderInfo]) return false;
			var theCallback : Function = callback != null ? callback : instance.defaultUncaughtErrorEventHandler;
			if (instance._callbacks[loaderInfo] != theCallback) return false;
			loaderInfo.uncaughtErrorEvents.removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, theCallback);
			instance._callbacks[loaderInfo] = null;
			delete instance._callbacks[loaderInfo];
			return true;
		}

		private function defaultUncaughtErrorEventHandler(event : UncaughtErrorEvent) : void
		{
			event.preventDefault();

			if (event.error is Error)
			{
				var erro : Error = event.error as Error;
				errorch(this, erro.getStackTrace());
			}
			else if (event.error is ErrorEvent)
			{
				var errorEvent : ErrorEvent = event.error as ErrorEvent;
				errorch(this, errorEvent.text, errorEvent.type, errorEvent.errorID);
			}
			else
			{
				errorch(this, event.error);
			}
		}
	}
}

internal class Key
{
}
