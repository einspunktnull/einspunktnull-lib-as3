package net.einspunktnull.audio.play
{
	/**
	 * @author Albrecht Nitsche
	 */
	public class SoundPlayerList
	{
		private var _array : Array = new Array();

		public function add(sndObj : SoundPlayer) : Boolean
		{
			if (!contains(sndObj))
			{
				_array.push(sndObj);
				return true;
			}
			return false;
		}

		public function remove(sndObj : SoundPlayer) : Boolean
		{
			if (contains(sndObj))
			{
				_array.splice(_array.indexOf(sndObj), 1);
				return true;
			}
			return false;
		}

		public function contains(sndObj : SoundPlayer) : Boolean
		{
			for each (var sndObj2 : SoundPlayer in _array) if (sndObj == sndObj2) return true;
			return false;
		}

		public function get(id:String) : SoundPlayer
		{
			for each (var sndObj : SoundPlayer in _array) if (sndObj.id == id) return sndObj;
			return null;
		}

		public function get length() : uint
		{
			return _array.length;
		}

		public function get array() : Array
		{
			return _array;
		}
	}
}
