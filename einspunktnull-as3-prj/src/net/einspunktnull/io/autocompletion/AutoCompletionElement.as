package net.einspunktnull.io.autocompletion
{
	import net.einspunktnull.display.util.DisplayObjectUtil;

	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * @author Albrecht Nitsche
	 */
	public class AutoCompletionElement extends Sprite
	{
		protected var _autoCompletionTextField : AutoCompletionTextField;
		private var _suggestionContainer : Sprite;

		public function AutoCompletionElement(entries : Array = null, delay : Number = 250, ignoreCase : Boolean = true, numLetters : uint = 0, wordsOnly : Boolean = true, autoSuggest : Boolean = false)
		{
			_autoCompletionTextField = new AutoCompletionTextField(entries, delay, ignoreCase, numLetters, wordsOnly, autoSuggest);
			addChild(_autoCompletionTextField);
			_autoCompletionTextField.multiline = false;
			_autoCompletionTextField.height = 20;
			_autoCompletionTextField.width = 200;
			_autoCompletionTextField.border = true;
			_autoCompletionTextField.addEventListener(AutoCompletionEvent.COMPLETIONS, onCompletions);
			_suggestionContainer = new Sprite();
			addChild(_suggestionContainer);
			_suggestionContainer.y = _autoCompletionTextField.height;
		}

		private function onCompletions(event : AutoCompletionEvent) : void
		{
			var suggestions : Array = event.completions;
			DisplayObjectUtil.removeAllChildren(_suggestionContainer);
			for (var i : int = 0; i < suggestions.length; i++)
			{
				var suggestion : String = suggestions[i] as String;
				var suggestionTF : TextField = new TextField();
				_suggestionContainer.addChild(suggestionTF);
				suggestionTF.selectable = false;
				suggestionTF.multiline = _autoCompletionTextField.multiline;
				suggestionTF.height = _autoCompletionTextField.height;
				suggestionTF.width = _autoCompletionTextField.width;
				suggestionTF.border = _autoCompletionTextField.border;
				suggestionTF.text = suggestion;
				suggestionTF.y = i * suggestionTF.height + 1;
			}
			_suggestionContainer.graphics.clear();
			_suggestionContainer.graphics.beginFill(0xeeeeee);
			_suggestionContainer.graphics.drawRect(0, 0, _autoCompletionTextField.width, _suggestionContainer.height);
		}

		public function addEntry(entry : String) : void
		{
			_autoCompletionTextField.addEntry(entry);
		}

		public function removeEntry(entry : String) : void
		{
			_autoCompletionTextField.removeEntry(entry);
		}

		public function get autoCompletionTextField() : AutoCompletionTextField
		{
			return _autoCompletionTextField;
		}
	}
}
