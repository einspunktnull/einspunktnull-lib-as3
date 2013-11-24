/*
Copyright (c) 2008 NascomASLib Contributors.  See:
    http://code.google.com/p/nascomaslib

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package be.nascom.flash.events
{
	import flash.events.Event;

	/**
	 * 
	 * A RemoteCallStatusEvent is dispatched after parsing the response of a remote call containing a success
	 * variable. For instance, a succeeded call might return a data validation error and a decription. This is
	 * ideally used as a base class.
	 * 
	 * @author David Lenaerts
	 * @mail david.lenaerts@nascom.be
	 * @see be.nascom.flash.events.RemoteCallResponseEvent
	 * 
 	 */

	public class RemoteCallStatusEvent extends Event
	{
		/**
		 * Defines the value of the type property of a status event object.
		 */
		 
		public static const STATUS : String = "status";
		
		private var _success : Boolean;
		private var _description : String;
		
		/**
		 * Creates an Event object that contains specific information about remote call status events.
		 */
		public function RemoteCallStatusEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Indicates whether the server accepts the sent data. If not, it might indicate that the sent data is
		 * not correct (input validation, incorrect id, ...)
		 */
		public function get success() : Boolean {
			return _success;
		}
		
		public function set success(value : Boolean) : void {
			_success = value;
		}
		
		/**
		 * A description of the status return. For instance, it could explain which of the sent data is wrong.
		 */
		public function get description() : String {
			return _description;
		}
		
		public function set description(value : String) : void {
			_description = value;
		}
	}
}