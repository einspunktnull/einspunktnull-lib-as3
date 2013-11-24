package net.einspunktnull.io.wordinput
{
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;

	/**
	 * @author Albrecht Nitsche
	 */
	public class WordInputListener extends EventDispatcher
	{

		private static var _instance : WordInputListener;
		private var _inputs : Array = new Array();

		public function WordInputListener(key : Key)
		{
		}

		private static function get instance() : WordInputListener
		{
			if (_instance == null) _instance = new WordInputListener(new Key());
			return _instance;
		}

		public static function register(doc : DisplayObjectContainer) : void
		{
			doc.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}

		public static function unregister(doc : DisplayObjectContainer) : void
		{
			doc.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}

		private static function onKeyUp(event : KeyboardEvent) : void
		{

			for each (var input : WordInput in instance._inputs)
			{
				var letter : String = String.fromCharCode(event.charCode);
				input.currentInput += letter;
				if (input.inputString.indexOf(input.currentInput) == 0)
				{
					if (input.inputString == input.currentInput)
					{
						input.currentInput = "";
						instance.dispatchEvent(new WordInputEvent(WordInputEvent.MATCH, input));
					}else{
						instance.dispatchEvent(new WordInputEvent(WordInputEvent.OBSERVE, input));
					}
				}
				else
				{
					input.currentInput = letter;
					instance.dispatchEvent(new WordInputEvent(WordInputEvent.IGNORE, input));
				}
			}
		}

		public  static function addInput(inputString : String) : void
		{
			var input : WordInput = new WordInput(inputString);
			instance._inputs.push(input);
		}


		public static function addEventListener(type : String, callback : Function) : void
		{
			instance.addEventListener(type, callback);
		}
	}
}

internal class Key
{
}
