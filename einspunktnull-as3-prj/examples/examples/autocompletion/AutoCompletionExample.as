package
examples.autocompletion{
	import net.einspunktnull.io.autocompletion.AutoCompletionElement;
	import net.einspunktnull.io.autocompletion.AutoCompletion;
	import net.einspunktnull.io.autocompletion.AutoCompletionEvent;
	import net.einspunktnull.io.autocompletion.AutoCompletionTextField;

	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * @author Albrecht Nitsche
	 */
	public class AutoCompletionExample extends Sprite
	{
		private const ENTRIES : Array = ["Karl", "Torsten", "andreas", "andi", "andrea", "andy", "karsten", "Anne"];

		public function AutoCompletionExample()
		{

			/*****************************************************
			 * AUTOCOMPLETION CORE
			 ****************************************************/
			var _ac : AutoCompletion = new AutoCompletion(ENTRIES, true);
			var results : Array = _ac.parse("an");
			for each (var completion : String in results)
			{
				logch(this, completion);
			}



			/*****************************************************
			 * AUTOCOMPLETION TEXTFIELD (suggestions per ctrl+shift+space)
			 ****************************************************/
			var actf : AutoCompletionTextField = new AutoCompletionTextField(ENTRIES, 300, true, 2, true);
			addChild(actf);
			actf.multiline = false;
			actf.height = 20;
			actf.width = 200;
			actf.border = true;
			var onCompletions : Function = function(event : AutoCompletionEvent) : void
			{
				ctf.text = event.completions ? event.completions.toString() : "";
			};
			actf.addEventListener(AutoCompletionEvent.COMPLETIONS, onCompletions);
			var ctf : TextField = new TextField();
			addChild(ctf);
			ctf.x = actf.width + 10;
			ctf.height = 20;
			ctf.width = 300;
			ctf.border = true;



			/*****************************************************
			 * AUTOCOMPLETION GUI ELEMENT
			 ****************************************************/
			var aceAutoSuggest : AutoCompletionElement = new AutoCompletionElement(ENTRIES, 300, true, 1, true, true);
			addChild(aceAutoSuggest);
			aceAutoSuggest.y = 100;

			var aceNoAutoSuggest : AutoCompletionElement = new AutoCompletionElement(ENTRIES, 300, true, 0, true, false);
			addChild(aceNoAutoSuggest);
			aceNoAutoSuggest.y = 100;
			aceNoAutoSuggest.x = aceAutoSuggest.width + 10;
			;

		}

	}
}
