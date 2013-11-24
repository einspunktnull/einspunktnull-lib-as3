package net.einspunktnull.audio.play
{
	import com.gskinner.motion.GTween;

	import flash.events.EventDispatcher;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;

	/**
	 * @author Albrecht Nitsche
	 */
	public class SoundPlayerManager  extends EventDispatcher implements ISoundPlayer
	{
		private static const ME : SoundPlayerManager = new SoundPlayerManager(InstanceLock);
		private var soundPlayers : SoundPlayerList = new SoundPlayerList();
		private var _volume : Number = 1;
		private var volumeTemp : Number;
		private var soundTransform : SoundTransform = new SoundTransform();
		private var fadeTween : GTween;

		public static function get me() : SoundPlayerManager
		{
			return ME;
		}

		public function SoundPlayerManager(key : Class) : void
		{
			if (key != InstanceLock) throw new Error("SoundManager is a Singleton. No Constructor!");
			reset();
			assignVolume();
		}

		public function reset() : void
		{
			for each (var sndObj : SoundPlayer in soundPlayers.array)
			{
				sndObj.reset();
				removeSoundObject(sndObj);
			}
			_volume = 1;
			volumeTemp = _volume;
		}

		public function addSoundObject(sndObj : SoundPlayer) : void
		{
			soundPlayers.add(sndObj);
		}

		public function removeSoundObject(sndObj : SoundPlayer) : void
		{
			soundPlayers.remove(sndObj);
		}

		public function play(soundPlayerID : String = "") : void
		{
			if (soundPlayerID != "") soundPlayers.get(soundPlayerID).play();
			else for each (var sndObj : SoundPlayer in soundPlayers.array) sndObj.play();
		}

		public function pause(soundPlayerID : String = "") : void
		{
			if (soundPlayerID != "") soundPlayers.get(soundPlayerID).pause();
			else for each (var sndObj : SoundPlayer in soundPlayers.array) sndObj.pause();
		}

		public function stop(soundPlayerID : String = "") : void
		{
			if (soundPlayerID != "") soundPlayers.get(soundPlayerID).stop();
			else for each (var sndObj : SoundPlayer in soundPlayers.array) sndObj.stop();
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
			soundTransform.volume = _volume;
			applySoundTransform();
		}

		public function fade(volume : Number, time : Number) : void
		{
			if (fadeTween) fadeTween.end();

			soundTransform.volume = this.volume;
			fadeTween = new GTween(soundTransform, time);
			fadeTween.setValue("volume", volume);
			fadeTween.onChange = applySoundTransform;
		}

		public function applySoundTransform(tween : GTween = null) : void
		{
			tween;
			SoundMixer.soundTransform = soundTransform;
		}

		public function get volume() : Number
		{
			return _volume;
		}

		public function set volume(volume : Number) : void
		{
			_volume = volume;
			assignVolume();
		}
	}
}
internal class InstanceLock
{
}



