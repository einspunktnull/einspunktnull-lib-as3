/*
Copyright (c) 2010, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.net/yui/license.txt
version: 1.0
*/
package net.einspunktnull.ylcmod
{
	import flash.events.Event;
	
	/*
	 * Custom event class for YLocalConnection, a customised
	 * child class of LocalConnection that is designed to
	 * facilitate the concept of a LocalConnection Group
	 */
	public class YLCEvent extends Event
	{
		public static const ALL_CONNECTED:String = "allConnected";
		public static const CONNECTION_CLOSED : String = "CONNECTION_CLOSED";

		public function YLCEvent (type:String)
		{
				   super(type);
		}
		
		override public function clone():Event{
				   return new YLCEvent(type);
		}
	}
}