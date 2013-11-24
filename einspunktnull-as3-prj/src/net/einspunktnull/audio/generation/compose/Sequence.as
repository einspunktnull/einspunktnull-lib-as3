package net.einspunktnull.audio.generation.compose
{
	/**
	 * @author Albrecht Nitsche
	 */
	public class Sequence
	{
		private var _tracks : Array = new Array();

		public function Sequence()
		{
		}

		public function addTrack(track : Track) : void
		{
			_tracks.push(track);
		}

		public function get tracks() : Array
		{
			return _tracks;
		}
	}
}
