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
	 * A RemoteCallResponseEvent is dispatched after a remote call returns unparsed content
	 * (such as xml, url-encoded data from php, ...).
	 * 
	 * @author David Lenaerts
	 * @mail david.lenaerts@nascom.be
	 * 
	 */
	
	public class RemoteCallResponseEvent extends Event
	{
		/**
		 * Defines the value of the type property of a response event object.
		 */
		public static const RESPONSE : String = "response";

		private var _response : *;
		
		/**
		 * Creates an Event object that contains the response content
		 */
		
		public function RemoteCallResponseEvent(type : String, response : *, bubbles : Boolean = false, cancelable : Boolean = false) {
			_response = response;
			trace (_response);
			super(type, bubbles, cancelable);
		}
		
		/**
		 * The unparsed response content returned by the server
		 */
		
		public function get response() : * {
			return _response;
		}
	}
}