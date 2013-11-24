package net.einspunktnull.audio.generation.generator
{
	import net.einspunktnull.audio.generation.compose.Track;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.ByteArray;

	/**
	 * @author Albrecht Nitsche
	 */
	public class SoundTrack extends EventDispatcher
	{
		private var _sound : Sound = new Sound();
		private var _soundChannel : SoundChannel;
		private var _track : Track;
		private var _soundBytes : ByteArray;

		public function SoundTrack(track : Track)
		{
			_track = track;
			_sound.addEventListener(SampleDataEvent.SAMPLE_DATA, fillSound);
		}
		
		public function play() : void
		{
			_soundBytes.position = 0;
			_soundChannel = _sound.play();
			_soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			
		}
		
		private function fillSound(event : SampleDataEvent) : void
		{
			var bytes : ByteArray = new ByteArray();
			_soundBytes.readBytes(bytes, 0, Math.min(_soundBytes.bytesAvailable, 8*8192));
			event.data.writeBytes(bytes, 0, bytes.length);
		}
		
		private function onSoundComplete(event : Event) : void
		{
			dispatchEvent(event);
		}

		public function set soundBytes(soundBytes : ByteArray) : void
		{
			_soundBytes = soundBytes;
			_soundBytes.position = 0;
		}

		public function get soundBytes() : ByteArray
		{
			return _soundBytes;
		}

		public function get track() : Track
		{
			return _track;
		}

	}
}
