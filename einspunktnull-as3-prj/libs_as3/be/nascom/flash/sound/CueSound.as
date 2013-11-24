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

package be.nascom.flash.sound
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import be.nascom.flash.events.CuePointEvent;

	/**
	 * The SoundSync class controls cuepoints on a soundObject.
	 * Example usage:
	 * 
	 * 	var ss:SoundSync = new SoundSync();
	   	ss.load(new URLRequest("green_presidents.mp3"));
	   	ss.addCuePoint("George Washington", 2877);
		ss.addCuePoint("Thomas Jefferson", 6000);
		ss.play();
		ss.addEventListener(CuePointEvent.CUE_POINT, onCuePoint);
		 * 
		private function onCuePoint(event:CuePointEvent):void {
			trace("Cue point: " + event.name + ", " + event.time);
		}
	 * 
	 * @see be.nascom.flash.events.CuePointEvent
	 * 
 	 * @author Rien Verbrugghe
	 * @mail rien.verbrugghe@nascom.be
	 * 
	 */
	 
	public class CueSound extends Sound
	{
		private var _cuePoints:Array;
		private var _currentCuePoint:uint;
		private var _timer:Timer;
		private var _timerInterval:uint;
		private var _startTime:Number;
		private var _loops:uint;
		private var _soundChannel:SoundChannel;

		public function CueSound(stream:URLRequest = null, context:SoundLoaderContext = null) {
			super(stream, context);
			init();
		}

		private function init():void {
			_cuePoints = new Array();
			_currentCuePoint = 0;
			_timerInterval = 50;
			_startTime = 0.0;
		}
		
		/**
		 * Add cuepoint on the sound object.
		 * 
		 * @param cuePointName A String with a chosen description
		 * @param cuePointTime A uint where the keypoint needs to be placed on the song object
		 */
		 
		public function addCuePoint(cuePointName:String, cuePointTime:uint):void {
			_cuePoints.push(new CuePointEvent(CuePointEvent.CUE_POINT, cuePointName, cuePointTime));
			_cuePoints.sortOn("time", Array.NUMERIC);
		}
		
		/**
		 * Get the CuePoint.
		 */
		 
		public function getCuePoint(nameOrTime:Object):Object {
			var counter:uint = 0;
			while (counter < _cuePoints.length) {
				if (typeof(nameOrTime) == "string") {
					if (_cuePoints[counter].name == nameOrTime) {
						return _cuePoints[counter];
					}
				} else if (typeof(nameOrTime) == "number") {
					if (_cuePoints[counter].time == nameOrTime) {
						return _cuePoints[counter];
					}
				}
				counter++;
			}
			return null;
		}
		
		/**
		 * Get Current Cue Point Index.
		 */
		 
		private function getCurrentCuePointIndex(cuePoint:CuePointEvent):uint {
			var counter:uint = 0;
			while (counter < _cuePoints.length) {
				if (_cuePoints[counter].name == cuePoint.name) {
					return counter;
				}
				counter++;
			}
			return null;
		}
		
		/**
		 * Get Next Cue Point Index.
		 */
		  
		private function getNextCuePointIndex(milliseconds:Number):uint {
			if (isNaN(milliseconds)) {
				milliseconds = 0;
			}
			var counter:uint = 0;
			while (counter < _cuePoints.length) {
				if (_cuePoints[counter].time >= milliseconds) {
					return counter;
				}
				counter++;
			}
			return null;
		}
		
		/**
		 * Remove Cue Point.
		 */
		 
		public function removeCuePoint(cuePoint:CuePointEvent):void {
			_cuePoints.splice(getCurrentCuePointIndex(cuePoint), 1);
		}
		
		/**
		 * Remove All Cue Points.
		 */
		 
		public function removeAllCuePoints():void {
			_cuePoints = new Array();
		}
		
		/**
		 * Play the sound with the cuepoints.
		 */
		 
		public override function play(startTime:Number = 0.0, loops:int=0, sndTransform:SoundTransform=null):SoundChannel {
			_soundChannel = super.play(startTime, loops, sndTransform);
			_soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundCompleteThis);
			dispatchEvent(new Event("play"));
			// Reset current cue point
			_startTime = startTime;
			_loops = 0; // our loops is different
			_currentCuePoint = getNextCuePointIndex(startTime);
			// Poll for cue points
			_timer = new Timer(_timerInterval);
			_timer.addEventListener(TimerEvent.TIMER, pollCuePoints);
			_timer.start();
			return _soundChannel;
		}
		
		/**
		 * Stop the sound with the cuepoints.
		 */
		 
		public function stop():void {
			_soundChannel.stop();
			dispatchEvent(new Event("stop"));
			// Kill polling
			_timer.stop();
		}
		
		/**
		 * Poll Cue Points.
		 */
		 
		private function pollCuePoints(event:TimerEvent):void {
			var time:Number = _cuePoints[_currentCuePoint].time + (length * _loops);
			var span:Number = 0;
			if (_cuePoints[_currentCuePoint + 1] == undefined) {
				span = time + _timerInterval * 2;
			} else {
				span = _cuePoints[_currentCuePoint + 1].time + (length * _loops);
			};
			if (_soundChannel.position >= time && _soundChannel.position <= span) {
				// Dispatch event
				dispatchEvent(_cuePoints[_currentCuePoint]);
				// Advance to next cue point ...
				if (_currentCuePoint < _cuePoints.length - 1) {
					_currentCuePoint++;
				} else {
					_currentCuePoint = getNextCuePointIndex(_startTime);
					_loops++;
				}
			}
		}
		
		/**
		 * onSoundComplete Event Dispatch.
		 */
		 
		public function onSoundCompleteThis(event:Event):void {
			// Reset current cue point
			_currentCuePoint = 0;
			// Kill polling
			_timer.stop();
			// Dispatch event
			dispatchEvent(new Event(Event.SOUND_COMPLETE));
		}
	}
}