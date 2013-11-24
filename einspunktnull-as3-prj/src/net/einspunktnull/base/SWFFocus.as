
package net.einspunktnull.base
{

	import flash.external.ExternalInterface;


	/**
	 * @author Albrecht Nitsche
	 */
	public class SWFFocus {

		private static var _instance : SWFFocus;
		private  var _callbackParams : Array;
		private  var _callback : Function;

		private var _hasFocus : Boolean = true;

		private static function get instance() : SWFFocus {
			if (_instance == null) _instance = new SWFFocus(new Key());
			return _instance;
		}

		public function SWFFocus(key : Key) {
		}

		public static function get hasFocus() : Boolean {
			return instance._hasFocus;
		}

		public static function init(hasFocus : Boolean, callerName : String, callback : Function = null, ...callbackParams) : void {
			instance._hasFocus = hasFocus;
			instance._callback = callback;
			instance._callbackParams = callbackParams;
			ExternalInterface.addCallback(callerName, instance.setHasFocus);
		}

		private function setHasFocus(hasFocus : Boolean) : void {
			instance._hasFocus = hasFocus;
			var callbackParams : Array = [instance._hasFocus];
			if (callbackParams != null) callbackParams = callbackParams.concat(instance._callbackParams);
			if (instance._callback != null) instance._callback.apply(null, callbackParams);
		}
	}
}

internal class Key {
}