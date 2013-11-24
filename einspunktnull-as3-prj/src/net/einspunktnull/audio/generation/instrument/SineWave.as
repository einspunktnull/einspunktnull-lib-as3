package net.einspunktnull.audio.generation.instrument
{
	import net.einspunktnull.audio.generation.compose.Note;

	import flash.utils.ByteArray;

	/**
	 * @author Albrecht Nitsche
	 */
	public class SineWave implements IInstrument
	{
		public function bytes(note : Note, bpm : uint) : ByteArray
		{
			var bytes : ByteArray = new ByteArray();

			var phase : Number = 0;

			var length : uint = note.time * 60/bpm  * 44100;

			for (var i : uint = 0; i < length; i++)
			{
				var value : Number = Math.sin(phase);
				bytes.writeFloat(value);
				bytes.writeFloat(value);
				phase += Math.PI * 2 * note.frequency / 44100;
			}
			return bytes;
		}
	}
}
