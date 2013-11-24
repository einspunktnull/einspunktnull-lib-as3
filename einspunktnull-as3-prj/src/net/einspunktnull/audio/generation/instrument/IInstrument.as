package net.einspunktnull.audio.generation.instrument
{
	import net.einspunktnull.audio.generation.compose.Note;

	import flash.utils.ByteArray;

	/**
	 * @author Albrecht Nitsche
	 */
	public interface IInstrument
	{
		function bytes(note : Note, bpm : uint) : ByteArray;
	}
}
