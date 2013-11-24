/*
Copyright (c) 2010, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.net/yui/license.txt
version: 1.0
 */
package net.einspunktnull.ylcmod {
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;

	/*
	 * Customised child class of LocalConnection that is designed
	 * to facilitate the concept of a LocalConnection Group, which
	 * is a single instance of SWFs that communicate to each other
	 * via LocalConnection. LocalConnection Groups do not interfere
	 * with each other so multiple instances of such SWFs can be
	 * open on a computer and work independently.
	 *
	 * More details: http://adspecs.yahoo.co.uk/guidelines/technical/lc 
	 */
	public class YLocalConnection extends LocalConnection {
		protected var MASTER_ID_BASE : String = 'master';
		protected var TEMP_ID_BASE : String = 'temp';
		protected var SLAVE_ID_BASE : String = 'slave';
		protected var _groupNumber : int;
		// unique number that is used in the IDs of all connections within the group to prevent interferences from other connection groups
		protected var _uniqId : String;
		// unique ID for each connected LC object in the LC Group
		protected var _userFunctionScope : Object;

		// where user defined function are defined and can be accessed by the LC Object
		public function YLocalConnection(prefix : String) {
			MASTER_ID_BASE = prefix + MASTER_ID_BASE;
			TEMP_ID_BASE = prefix + MASTER_ID_BASE;
			SLAVE_ID_BASE = prefix + MASTER_ID_BASE;
		}

		public function makeConnection() : void {
			this.allowDomain('*');
			this.client = this;
			this.addEventListener(StatusEvent.STATUS, onConnStatus);
			this.connect(_uniqId);
		}

		protected function onConnStatus(e : StatusEvent) : void {
			switch (e.level) {
				case "status":
					trace("status", _uniqId + ".send() succeeded");
					break;
				case "error":
					trace("error", _uniqId + ".send() succeeded");
					break;
			}
		}

		public function callUserFunction(funcName : String, param : Array) : void {
			(_userFunctionScope[funcName] as Function).apply(null, param);
		}

		public function get uniqId() : String {
			return _uniqId;
		}
	}
}