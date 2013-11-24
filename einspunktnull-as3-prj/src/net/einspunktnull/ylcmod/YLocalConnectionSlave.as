/*
Copyright (c) 2010, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.net/yui/license.txt
version: 1.0
 */
package net.einspunktnull.ylcmod {
	import flash.events.StatusEvent;

	/*
	 * A Slave child class of YLocalConnection, which is a
	 * customised child class of LocalConnection that is designed
	 * to facilitate the concept of a LocalConnection Group. A
	 * LocalConnection Group can have many slaves. A Slave only
	 * has access to the Master and not other Slaves.
	 */
	public class YLocalConnectionSlave extends YLocalConnection {
		private var _slaveNumber : int;
		private var connected : Boolean = false;

		// starting from 1 for the first slave and increment 1 for each subsequent slave
		public function YLocalConnectionSlave(slaveNum : int, userFnScope : Object, prefix : String = "") {
			super(prefix);
			_slaveNumber = slaveNum;
			_userFunctionScope = userFnScope;
			_uniqId = TEMP_ID_BASE + _slaveNumber.toString();
		}

		/*
		 * The LocalConnection Group concept works on the
		 * assumption that SWFs of a Group always load together, eg,
		 * when they are embedded on the same webpage. A Slave
		 * connects to a temporary connection name before getting
		 * contacted by the Master to be sent the unique Group number
		 * and reconnect(), hence formally joining the Group
		 */
		public function reconnect(groupNum : int) : void {
			_groupNumber = groupNum;

			_uniqId = SLAVE_ID_BASE + _slaveNumber.toString() + "_" + _groupNumber.toString();

			this.close();

			this.client = this;
			this.addEventListener(StatusEvent.STATUS, onConnStatus);
			this.connect(_uniqId);

			this.send(MASTER_ID_BASE + _groupNumber.toString(), "confirmRetrieval");

			connected = true;
		}

		/*
		 * Enables the Slave to invoke user defined methods on the
		 * Master connection
		 */
		public function sendToMaster(funcName : String, ...args) : void {
			this.send(MASTER_ID_BASE + _groupNumber.toString(), 'callUserFunction', funcName, args);
		}

		public function breakConnection() : Boolean {
			if (connected) {
				this.send(MASTER_ID_BASE + _groupNumber.toString(), "breakConnection");
				connected = false;
				return true;
			}
			return false;
		}
	}
}