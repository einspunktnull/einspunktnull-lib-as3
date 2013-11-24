package net.einspunktnull.audio.generation.compose
{
	import net.einspunktnull.audio.generation.instrument.IInstrument;
	/**
	 * @author Albrecht Nitsche
	 */
	public class Track
	{
		private var _id : String;
		private var _notes : Array = new Array();
		private var _instrument:IInstrument;
		
		public function Track(id:String, instrument:IInstrument)
		{
			_id = id;
			_instrument = instrument;
		}


		public function addNote(note : Note) : void
		{
			_notes.push(note);
		}

		public function get notes() : Array
		{
			return _notes;
		}

		public function get id() : String
		{
			return _id;
		}

		public function get instrument() : IInstrument
		{
			return _instrument;
		}

	}
}
