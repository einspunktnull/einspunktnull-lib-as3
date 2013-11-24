package net.einspunktnull.io.wordinput
{
	/**
	 * @author Albrecht Nitsche
	 */
	public class WordInput
	{
		private var _inputString : String;
		public var currentInput : String = "";

		public function WordInput(inputString : String)
		{
			_inputString = inputString;
		}

		public function get inputString() : String
		{
			return _inputString;
		}

	}
}
