package net.einspunktnull.audio.generation.compose
{
	/**
	 * @author Albrecht Nitsche
	 */
	public class Note
	{
		private var _frequency : Number;
		private var _time : Number;

		public function Note(frequency : Number, time : Number)
		{
			this._frequency = frequency;
			this._time = time;
		}

		public function get frequency() : Number
		{
			return _frequency;
		}

		public function get time() : Number
		{
			return _time;
		}
	}
}
