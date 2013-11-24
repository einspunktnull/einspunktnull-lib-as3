/*
Copyright (c) 2010, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.net/yui/license.txt
version: 1.0
 */
package net.einspunktnull.ylcmod {
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/*
	 * A Master child class of YLocalConnection, which is a
	 * customised child class of LocalConnection that is designed
	 * to facilitate the concept of a LocalConnection Group. A
	 * LocalConnection Group can have only 1 Master. A Master has
	 * access to all Slaves.
	 */
	public class YLocalConnectionMaster extends YLocalConnection {
		private var totalConnections : int;
		// total number of slaves that are meant to be connected to this master
		private var connectionsFound : int = 0;
		// slave connections that have been found so far
		private var checkSlavesTimer : Timer;
		private var i : int;

		public function YLocalConnectionMaster(totalConn : int, userFnScope : Object, prefix : String = "") {
			super(prefix);
			totalConnections = totalConn;
			_userFunctionScope = userFnScope;
			_groupNumber = Math.round(Math.random() * 1000000);
			// generates the unique Group number
			_uniqId = MASTER_ID_BASE + _groupNumber.toString();
		}

		override public function makeConnection() : void {
			super.makeConnection();

			startSlavesWatching();
		}

		private function startSlavesWatching() : void {
			checkSlavesTimer = new Timer(100);
			checkSlavesTimer.addEventListener(TimerEvent.TIMER, checkSlaves);
			checkSlavesTimer.start();
		}

		/*
		 * Looks for Slaves waiting to be connected and tries to
		 * connect them. If all Slaves are found and connected
		 * then dispatches event to indicate this
		 */
		private function checkSlaves(e : TimerEvent) : void {
			if (connectionsFound == totalConnections) {
				checkSlavesTimer.stop();
				dispatchEvent(new YLCEvent(YLCEvent.ALL_CONNECTED));
			} else {
				for (i = 0; i < totalConnections; i++) {
					this.send(TEMP_ID_BASE + i.toString(), "reconnect", _groupNumber);
				}
			}
		}

		/*
		 * Closes all Slave connections and then the Master connection
		 */
		public function closeAllConnections() : void {
			for (i = 0; i < totalConnections; i++) {
				this.send(SLAVE_ID_BASE + i.toString() + "_" + _groupNumber.toString(), "close");
			}
			this.close();
		}

		/*
		 * This is called by a newly connected Slave
		 */
		public function confirmRetrieval() : void {
			connectionsFound++;
		}

		public function breakConnection() : void {
			connectionsFound--;
			dispatchEvent(new YLCEvent(YLCEvent.CONNECTION_CLOSED));
			startSlavesWatching();
		}

		/*
		 * Enables the Master to invoke user defined methods on a
		 * Slave connection
		 */
		public function sendToSlave(slaveNum : int, funcName : String, ...args) : void {
			this.send(SLAVE_ID_BASE + slaveNum.toString() + "_" + _groupNumber.toString(), 'callUserFunction', funcName, args);
		}

		/*
		 * Enables the Master to invoke user defined methods on all
		 * Slave connections
		 */
		public function sendToAllSlaves(funcName : String, ...args) : void {
			for (i = 0; i < totalConnections; i++) {
				this.send(SLAVE_ID_BASE + i.toString() + "_" + _groupNumber.toString(), 'callUserFunction', funcName, args);
			}
		}
	}
}