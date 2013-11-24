package net.einspunktnull.audio.generation.generator
{
	import net.einspunktnull.audio.generation.compose.Note;
	import net.einspunktnull.audio.generation.compose.Sequence;
	import net.einspunktnull.audio.generation.compose.Track;

	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;

	/**
	 * @author Albrecht Nitsche
	 */
	public class SoundGenerator extends EventDispatcher
	{
		private var _sequence : Sequence;
		private var _bpm : uint;
		private var _soundTracks : Array = new Array();

		public function render() : void
		{
			if (_sequence != null && _soundTracks.length > 0)
			{
				for each (var soundTrack : SoundTrack in _soundTracks)
				{
					soundTrack.soundBytes = createSoundBytes(soundTrack);
				}
			}
		}

		private function createSoundBytes(soundTrack : SoundTrack) : ByteArray
		{
			var bytes : ByteArray = new ByteArray();
			for each (var note : Note in soundTrack.track.notes)
			{
				bytes.writeBytes(soundTrack.track.instrument.bytes(note, bpm));
			}
			return bytes;
		}

		public function get sequence() : Sequence
		{
			return _sequence;
		}

		public function set sequence(sequence : Sequence) : void
		{
			_sequence = sequence;
			while (_soundTracks.length) _soundTracks.pop();
			for each (var track : Track in _sequence.tracks)
			{
				_soundTracks.push(new SoundTrack(track));
			}
		}

		public function play() : void
		{
			for each (var soundTrack : SoundTrack in _soundTracks) 
			{
				soundTrack.play();
			}
		}

		public function get bpm() : uint
		{
			return _bpm;
		}

		public function set bpm(bpm : uint) : void
		{
			_bpm = bpm;
		}
	}
}
