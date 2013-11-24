package net.einspunktnull.audio.generation.instrument
{
	import net.einspunktnull.audio.generation.compose.Note;

	import flash.utils.ByteArray;

	/**
	 * @author Albrecht Nitsche
	 */
	public class SquareWave implements IInstrument
	{
		public function bytes(note : Note, bpm : uint) : ByteArray
		{
			var bytes : ByteArray = new ByteArray();

			var phase : Number = 0;

			var length : uint = note.time * 60/bpm  * 44100;
			
			var step : Number = Math.PI * 2 * note.frequency / 44100;
			trace(step);

			for (var i : uint = 0; i < length; i++)
			{
				var value : Number = Math.sin(phase);
				if(value>0)value = 1;
				if(value<0)value = -1;
				bytes.writeFloat(value);
				bytes.writeFloat(value);
				phase += step;
			}
			return bytes;
		}
	}
}
