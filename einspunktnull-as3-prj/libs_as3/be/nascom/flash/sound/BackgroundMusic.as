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
	import com.greensock.TweenLite;
	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	/**
	 * The static BackgroundMusic class controls background music throughout a whole site. Currently, it only
	 * supports playback from a reference embedded in the library.
	 *
	 * 
 	 * @author David Lenaerts
	 * @mail david.lenaerts@nascom.be
	 * 
	 */

	public class BackgroundMusic
	{
		private static var _music : Sound;
		private static var _classReference : Class;
		
		private static var _channel : SoundChannel;
		
		private static var _volume : Number = 1;
		private static var _outputVolume : Number = 1;
		
		private static var _muted : Boolean = false;
		
		/**
		 * Start playback of the background music.
		 * 
		 * @param soundClassName A Class reference to a sound asset in the Flash Library.
		 */
		public static function play(soundClassName : Class = null) : void {
			if (soundClassName != _classReference) {
				stop();
				if (soundClassName) {
					_classReference = soundClassName;
					_music = new soundClassName();
					_channel = _music.play(0, 1000000);
					if (!_muted) {
						outputVolume = _volume;
					}
					else {
						outputVolume = 0;
					}
				}
			}
		}
		
		/**
		 * Loads a sound asset for playback
		 * 
		 * @param filename The filename of the sound object
		 */
		public static function loadSound(filename : String) : void
		{
			if (_channel)
				_channel.stop();
			
			if (_music) _music.close();
			
			_music = new Sound(new URLRequest(filename));
			_channel = _music.play(0, 1000000);
		}
		
		/**
		 * Stops playback of the background music.
		 */
		public static function stop() : void {
			if (_channel)
				_channel.stop();
		}
		
		/**
		 * Mutes the output of the background music or resets it to the right amount.
		 * 
		 * @param fadeSpeed The amount of time it takes for the sound to fade in or out.
		 */
		public static function toggleMute(fadeSpeed : Number = 1) : void {
			_muted = !_muted;
			if (_channel)
				if (_muted)
					fadeOutMute(fadeSpeed);
				else
					fadeInMute(fadeSpeed);
		}
		
		
		/**
		 * The volume of the sound in unmuted state. Changing this value will not affect the output volume if muted,
		 * but when unmuted it will revert to the new value. This allows a volume control seperate from a mute control.
		 */
		
		public static function get volume() : Number {
			return _volume;
		}
		
		public static function set volume(value : Number) : void {
			_volume = value;
			if (!_muted)
				outputVolume = value;
		}
		
		/**
		 * Fades playback volume to a desired volume. This will not affect the output volume if muted, but when unmuted 
		 * it will revert to the new value. This allows a volume control seperate from a mute control.
		 */
		public static function fade(speed : Number, targetVolume : Number) : void {
			trace ("fading in");
			TweenLite.to(BackgroundMusic, speed, {volume:targetVolume});
		}
		
		/**
		 * Fades out to mute playback. This is different from the public fadeOut in that fadeOut only affects the
		 * unmuted volume.
		 */
		private static function fadeOutMute(speed : Number) : void {
			trace ("fading out");
			TweenLite.to(BackgroundMusic, speed, {outputVolume:0});
		}
		
		/**
		 * Fades in to unmute playback. This is different from the public fadeIn in that fadeIn only affects the
		 * unmuted volume.
		 */
		private static function fadeInMute(speed : Number) : void {
			trace ("fading in");
			TweenLite.to(BackgroundMusic, speed, {outputVolume:_volume});
		}
		
		/**
		 * @private Changes the actual volume of the output. It should NOT be used. It is only made public
		 * so the Tweening engine has access to it.
		 */
		public static function get outputVolume() : Number {
			return _outputVolume;
		}
		
		public static function set outputVolume(value : Number) : void {
			if (_channel) {
				var transform:SoundTransform = _channel.soundTransform;
				
				_outputVolume = value;
				transform.volume = _outputVolume;
				_channel.soundTransform = transform;
			}
		}
	}
}