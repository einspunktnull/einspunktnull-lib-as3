package net.einspunktnull.io.autocompletion
{
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import flash.utils.Timer;

	/**
	 * @author Albrecht Nitsche
	 */
	public class AutoCompletionTextField extends TextField
	{
		// TODO: aufklappe(auto aufklapp), replacement-ShortCut(aufklapp, wenn mehr als 1, ansonsten replace)

		private var _delay : Number;
		private var _ignoreCase : Boolean;
		private var _numLetters : uint;
		private var _timer : Timer;
		private var _ac : AutoCompletion;
		private var _entries : Array;
		private var _wordsOnly : Boolean;
		private var _completions : Array = [];
		private var _endIndex : int;
		private var _beginIndex : int;
		private var _autoSuggest : Boolean;

		public function AutoCompletionTextField(entries : Array = null, delay : Number = 250, ignoreCase : Boolean = true, numLetters : uint = 0, wordsOnly : Boolean = true, autoSuggest : Boolean = false)
		{
			type = TextFieldType.INPUT;
			_entries = entries;
			_delay = delay;
			_ignoreCase = ignoreCase;
			_numLetters = numLetters;
			_wordsOnly = wordsOnly;
			_autoSuggest = autoSuggest;
			init();
		}

		private function init() : void
		{
			_ac = new AutoCompletion(_entries, _ignoreCase);
			addEventListener(FocusEvent.FOCUS_IN, onFocusChange);
			addEventListener(FocusEvent.FOCUS_OUT, onFocusChange);
			_timer = new Timer(_delay);
			_timer.addEventListener(TimerEvent.TIMER, parse);
		}

		private function onFocusChange(event : FocusEvent) : void
		{
			switch(event.type)
			{
				case FocusEvent.FOCUS_IN:
					addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
					break;
				case FocusEvent.FOCUS_OUT:
					removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
					break;
			}
		}

		private function onKeyUp(event : KeyboardEvent) : void
		{
			if (event.shiftKey && event.ctrlKey && event.keyCode == Keyboard.SPACE)
			{
				if (_completions.length == 1)
				{
					replace();
				}
				else
				{
					parse();
					dispatchEvent(new AutoCompletionEvent(AutoCompletionEvent.COMPLETIONS, _completions));
				}
			}
			if (_timer.running) _timer.reset();
			_timer.start();
		}

		private function replace() : void
		{
			var oldText : String = text;
			var newText : String = oldText.substr(0, _beginIndex);
			newText += _completions[0] ;
			newText += oldText.substring(_endIndex + 1, oldText.length);
			text = newText;
			var selectionIndex : uint = _beginIndex + String(_completions[0]).length;
			setSelection(selectionIndex, selectionIndex);
		}

		private function parse(event : TimerEvent = null) : void
		{
			if (_timer.running)
			{
				_timer.reset();
			}

			var phrase : String;
			if (_wordsOnly)
			{
				_endIndex = selectionEndIndex;
				_beginIndex = _endIndex;
				var end : Boolean = false;
				while ( !end)
				{
					if (_beginIndex <= 0)
					{
						end = true;
						break;
					}
					var charBefore : String = text.charAt(_beginIndex - 1);
					if (charBefore == "" || charBefore == " " || charBefore == null)
					{
						end = true;
						break;
					}
					_beginIndex--;
				}
				phrase = text.substring(_beginIndex, _endIndex);
			}
			else
			{
				phrase = text;
			}

			if (phrase.length >= _numLetters)
			{
				_completions = _ac.parse(phrase);
			}
			else
			{
				_completions = [];
			}
			if (_autoSuggest) dispatchEvent(new AutoCompletionEvent(AutoCompletionEvent.COMPLETIONS, _completions));
		}

		public function addEntry(entry : String) : void
		{
			_ac.addEntry(entry);
		}

		public function removeEntry(entry : String) : void
		{
			_ac.removeEntry(entry);
		}
	}
}
