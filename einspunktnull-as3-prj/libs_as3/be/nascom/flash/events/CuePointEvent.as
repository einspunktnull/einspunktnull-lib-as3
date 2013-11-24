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
	 * A CuePointEvent is broadcasted when a cuepoint action occurs and the name of the cuepoint is needed.
	 * 
	 * @see be.nascom.flash.sound.SoundSync
	 * 
	 * @author Rien Verbrugghe
	 * @mail rien.verbrugghe@nascom.be
	 */
	 
	public class CuePointEvent extends Event
	{
		/**
		 * Broadcasted when a cuepoint has been detected.
		 */
		public static const CUE_POINT:String = "cuePoint";
    	public var name:String;
    	public var time:uint;
    
    	/**
		 * Creates a CuePointEvent instance, providing a cuePointName & cuePointTime.
		 */
		public function CuePointEvent(type:String, cuePointName:String, cuePointTime:uint, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			this.name = cuePointName;
      		this.time = cuePointTime;
		}
		
		public override function clone():Event
    	{
      		return new CuePointEvent(type, name, time, bubbles, cancelable);
    	}

	}
}