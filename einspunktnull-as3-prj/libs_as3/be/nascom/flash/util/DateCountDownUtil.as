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

package be.nascom.flash.util
{
    import be.nascom.flash.events.DateCountDownEvent;
    
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.TimerEvent;
    import flash.text.*;
    import flash.utils.Timer;
	
	/** 
	 * DateCountDown is used to coun how much time has elapsed since a particular date or how much time you still need to wait to reach a specific date.
	 * 
	 * @example The following code creates a DateCountDown from 31 aug 2009 at 14:58:59.
	 * 	<listing version="3.0">
	 * 		dc = new DateCountDown(DateCountDownEvent.COUNT_DOWN);
	 *		dc.addEventListener(DateCountDownEvent.COUNT_DOWN, dcHandler);
	 *		dc.StartWithEndDate(2009, 08, 31, 14, 58, 59)
	 * 
	 * 		private function dcHandler(event:DateCountDownEvent):void
	 *		{
	 *			trace(event.days+":"+event.hours+":"+event.minutes+":"+event.seconds);
	 *		}
	 * </listing>
	 * 
	 * @see be.nascom.flash.events.DateCountDownEvent
	 *  
	 * @author Rien Verbrugghe
	 * @mail rien.verbrugghe@nascom.be
	 * 
 	 */
 	 
    public class DateCountDownUtil extends EventDispatcher
    {
        private var _timer:Timer;
        private var _startTime:Number;
        private var _expireTime:Number;
        private var _range:Number;
        private var _type:String = DateCountDownEvent.COUNT_DOWN;
		
		/**
        * Specify if you want to countdown till a specific date or count up on a passed date.
        */
        public function DateCountDownUtil(type:String):void
        {
            super();
            
            _type = type;
        }
        
        /**
        * Specify the goal date to count to or from as seperate parameters.
        */
        public function StartWithEndDate(year:int, month:int=1, day:int=1, hour:int=0, minute:int=0, second:int=0, ms:int=0, refreshSecs:Number=1):void
        {
            _startTime = new Date().getTime();
            _expireTime = new Date(year, month-1, day, hour, minute, second, ms).getTime();
            _range = _expireTime - _startTime;
            _timer = new Timer(refreshSecs * 1000);
            init();
        }
        
        /**
        * Specify the goal date to count to or from as milliseconds.
        */
        public function StartWithEndDateInMilliseconds(milliSecs:int, refreshSecs:Number=1):void
        {
        	_startTime = new Date().getTime();
            _expireTime = milliSecs;
            _range = _expireTime - _startTime;
            _timer = new Timer(refreshSecs * 1000);
            init();
        }
        
        /**
        * Inits the countdown or countup.
        */
        private function init():void
        {
        	_timer.addEventListener(TimerEvent.TIMER, refresh);
            _timer.start();
            refresh();
        }

        /**
        * Refreshes countdown display.
        */
        public function refresh(evt:Event=null):void
        {
            var elapsed:Number = new Date().getTime()-_startTime;
            
            if(_type==DateCountDownEvent.COUNT_DOWN){
            	_getTimeDisplay(_range-elapsed);
            }else{
            	//to count how many time has passed
            	_getTimeDisplay(elapsed);
            }
        }

        /**
        * Generates countdown string from remaining time value.
        */
        private function _getTimeDisplay(remainder:Number):void
        {
            // days
            var numDays:Number = Math.floor(remainder/86400000);
            var days:String = (numDays < 10 ? "0" : "") + numDays.toString();
            remainder = remainder - (numDays*86400000);

            // hours
            var numHours:Number = Math.floor(remainder/3600000);
            var hours:String = (numHours < 10 ? "0" : "") + numHours.toString();
            remainder = remainder - (numHours*3600000);

            // minutes
            var numMinutes:Number = Math.floor(remainder/60000);
            var minutes:String = (numMinutes < 10 ? "0" : "") + numMinutes.toString();
            remainder = remainder - (numMinutes*60000);

            // seconds
            var numSeconds:Number = Math.floor(remainder/1000);
            var seconds:String = (numSeconds < 10 ? "0" : "") + numSeconds.toString();
            remainder = remainder - (numSeconds*1000);

            // milliseconds
            var numMilliseconds:Number = Math.floor(remainder/10);
            var milliseconds:String = (numMilliseconds < 10 ? "0" : "") + numMilliseconds.toString();
			
			
			if( (numDays==0) && (numHours==0) && (numMinutes==0) && (numSeconds==0)){
				dispatchEvent(new DateCountDownEvent(days, hours, minutes, seconds, milliseconds, DateCountDownEvent.COMPLETE) );
			}else if(_range < 0){
				dispatchEvent(new DateCountDownEvent(days, hours, minutes, seconds, milliseconds, DateCountDownEvent.COMPLETE) );
			}else{
				dispatchEvent(new DateCountDownEvent(days, hours, minutes, seconds, milliseconds, _type) );
			}
        }
        
        /**
        * Disposes of countdown display so that it is eligible for garbage collection.
        */
        public function dispose():void
        {
            _timer.stop();
            _timer.removeEventListener(TimerEvent.TIMER, refresh);
            _timer = null;
        }
    }
}