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
	 * An object dispatches a PageEvent when user interaction (or any other form of response) requests a page
	 * in the Flex or Flash site. The requested page is represented as an identifier String and is passed
	 * with the event. There is currently only one type of PageEvent:
	 * 
	 * <ul>
	 * <li><code>PageEvent.PAGE_REQUEST</code></li>
	 * </ul>
	 * 
	 * @author David Lenaerts
	 * @mail david.lenaerts@nascom.be
	 * 
 	 */

	public class PageEvent extends Event
	{
		/**
		 * Defines the value of the type property of a pageRequest event object.
		 */
		 
		public static const PAGE_REQUEST : String = "pageRequest";
		
		private var _pageId : String;
		
		/**
		 * Creates an Event object that contains specific information about page events.
		 * It requires the identifier String for the requested page.
		 */
		
		public function PageEvent(type : String, pageId : String, bubbles : Boolean = true, cancelable : Boolean = false) : void {
			_pageId = pageId;
			super(type, bubbles, cancelable);
		}
		
		/**
		 * The identifier String of the requested page.
		 */
		
		public function get pageId() : String {
			return _pageId;
		}
	}
}