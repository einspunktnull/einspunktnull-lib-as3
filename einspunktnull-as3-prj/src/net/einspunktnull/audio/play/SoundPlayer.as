package net.einspunktnull.audio.play
{
	import com.gskinner.motion.GTween;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	/**
	 * @author Albrecht Nitsche
	 */
	public class SoundPlayer extends EventDispatcher implements ISoundPlayer
	{
		private const STATE_PLAY : String = "play";
		private const STATE_PAUSE : String = "pause";
		private const STATE_STOP : String = "stop";
		private var snd : Sound;
		private var _id : String = "";
		private var _soundChannel : SoundChannel;
		private var _position : Number;
		private var state : String;
		private var _loop : Boolean = false;
		private var _volume : Number;
		private var volumeTemp : Number;
		private var fadeTween : GTween;
		private var soundTransform : SoundTransform = new SoundTransform();

		public function SoundPlayer(snd : Sound = null, id : String = null, volume : Number = 1, loop : Boolean = false)
		{
			this.snd = snd;
			this.id = id;
			this.volume = volume;
			this.loop = loop;
			reset();
		}

		public function reset() : void
		{
			_position = 0;
			state = STATE_PLAY;
			stop();
			_soundChannel = null;
			volumeTemp = _volume;
		}

		public function get soundChannel() : SoundChannel
		{
			return _soundChannel;
		}

		public function play(soundPlayerID:String = "") : void
		{
			if (state == STATE_STOP || state == STATE_PAUSE)
			{
				state = STATE_PLAY;
				dispatchEvent(new SoundPlayerEvent(SoundPlayerEvent.PLAY));
				_soundChannel = snd.play(_position);
				assignVolume();
				if (!_soundChannel.hasEventListener(Event.SOUND_COMPLETE)) _soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			}
		}

		public function pause(soundPlayerID:String = "") : void
		{
			if (state == STATE_PLAY)
			{
				state = STATE_PAUSE;
				dispatchEvent(new SoundPlayerEvent(SoundPlayerEvent.PAUSE));
				_position = _soundChannel.position;
				_soundChannel.stop();
			}
		}

		public function stop(soundPlayerID:String = "") : void
		{
			if (_soundChannel != null && _soundChannel.hasEventListener(Event.SOUND_COMPLETE)) _soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			if (state == STATE_PLAY || state == STATE_PAUSE)
			{
				state = STATE_STOP;
				dispatchEvent(new SoundPlayerEvent(SoundPlayerEvent.STOP));
				_position = 0;
				if (_soundChannel != null) _soundChannel.stop();
			}
		}

		public function toggleVolume() : void
		{
			if (_volume == 0) _volume = volumeTemp;
			else
			{
				volumeTemp = _volume;
				_volume = 0;
			}
			assignVolume();
		}

		public function assignVolume() : void
		{
			if (_soundChannel != null)
			{
				soundTransform.volume = _volume;
				applySoundTransform();
			}
		}

		private function onSoundComplete(event : Event) : void
		{
			reset();
			if (_loop) play();
		}

		public function fade(volume : Number, time : Number) : void
		{
			if (fadeTween) fadeTween.end();

			soundTransform.volume = this.volume;
			fadeTween = new GTween(soundTransform, time);
			fadeTween.setValue("volume", volume);
			fadeTween.onChange = applySoundTransform;
		}
		
		public function applySoundTransform(tween:GTween=null):void
		{
			tween;
			_soundChannel.soundTransform = soundTransform;
		}


		public function get id() : String
		{
			return _id;
		}

		public function set id(id : String) : void
		{
			_id = id;
		}

		public function get position() : Number
		{
			return _position;
		}

		public function get loop() : Boolean
		{
			return _loop;
		}

		public function set loop(loop : Boolean) : void
		{
			_loop = loop;
		}

		public function get volume() : Number
		{
			return _volume;
		}

		public function set volume(volume : Number) : void
		{
			this._volume = volume;
			if (state == STATE_PLAY) assignVolume();
		}
	}
}
