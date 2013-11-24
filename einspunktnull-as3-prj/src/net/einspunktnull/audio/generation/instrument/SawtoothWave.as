package net.einspunktnull.audio.generation.instrument
{
	import net.einspunktnull.audio.generation.compose.Note;

	import flash.utils.ByteArray;

	/**
	 * @author Albrecht Nitsche
	 */
	public class SawtoothWave implements IInstrument
	{
		public function bytes(note : Note, bpm : uint) : ByteArray
		{
			var bytes : ByteArray = new ByteArray();

			var length : uint = note.time * 60 / bpm * 44100;

			var step : Number = 44100/note.frequency;
			
			var count:Number = 1;
			
			for (var i : uint = 0; i < length; i++)
			{
				count-=2/step;
				if(count<=-1)count=1;
				bytes.writeFloat(count);
				bytes.writeFloat(count);
			}
			return bytes;
		}
	}
}
