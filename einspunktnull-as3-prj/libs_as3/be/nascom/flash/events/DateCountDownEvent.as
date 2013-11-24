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
	 * A DateCountDownEvent is broadcasted when a countdown action occurs and the new time is needed.
	 * 
	 * @see be.nascom.flash.util.DateCountDown
	 *  
	 * @author Rien Verbrugghe
	 * @mail rien.verbrugghe@nascom.be
	 * 
 	 */
 	 
	public class DateCountDownEvent extends Event
	{
		/**
		 * Broadcasted when a countdown action occurs or needs to be specified when initiating the DateCountDown class
		 */
		public static const COUNT_DOWN:String = "countDown";
		public static const COUNT_UP:String = "countUp";
		public static const COMPLETE:String = "complete";
		
		public var days:String;
    	public var hours:String;
    	public var minutes:String
    	public var seconds:String;
    	public var milliseconds:String;
    	
    	/**
		 * Creates a DateCountDownEvent instance, providing all timings needed.
		 */
		public function DateCountDownEvent(days:String, hours:String, minutes:String, seconds:String, milliseconds:String, type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.days = days;
      		this.hours = hours;
      		this.minutes = minutes;
      		this.seconds = seconds;
      		this.milliseconds = milliseconds;
		}
	}
}