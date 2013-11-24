package net.einspunktnull.typography.fx.slotmachine
{
	import net.einspunktnull.typography.fx.ITFX;
	import net.einspunktnull.typography.fx.TFX;

	import com.gskinner.motion.GTween;

	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * @author Albrecht Nitsche
	 */
	public class TFXSlotMachine extends TFX implements ITFX
	{
		private var containerHiddenTextField : Sprite = new Sprite();
		private var containerLetters : Sprite = new Sprite();
		private var letters : Array = new Array();
		private var tmpLetters : Array = new Array();
		private var updateStep : Number;
		private var updateCount : uint;
		private var tween : GTween;
		public var percent : Number;

		public function TFXSlotMachine(textField : TextField, params : TFXSlotMachineParams = null)
		{
			if (params == null) params = new TFXSlotMachineParams();
			super(textField, params);
			updateStep = 1 / textField.length;
			updateCount = 0;
			addChild(containerHiddenTextField);
			addChild(containerLetters);
			containerHiddenTextField.addChild(textField);
			createLetters();
			containerLetters.visible = false;
			containerHiddenTextField.visible = false;
		}

		public function start() : void
		{
			reset();
			startTween();
		}

		public function reset() : void
		{
			containerLetters.visible = true;
			while (tmpLetters.length) tmpLetters.pop();
			for each (var letter : Letter in letters)
			{
				tmpLetters.push(letter);
				letter.reset();
			}
			percent = 0;
		}

		private function createLetters() : void
		{
			for (var i : uint = 0; i < textField.length; i++)
			{
				var letter : Letter = new Letter(textField, i);
				letter.x = textField.getCharBoundaries(i).x - 2 + letter.width / 2 + textField.x;
				letter.y = textField.getCharBoundaries(i).y - 2 + letter.height / 2 + textField.y;
				letters.push(letter);
				containerLetters.addChild(letter);
			}
		}

		private function startTween() : void
		{
			
			if (params != null && !isNaN(TFXSlotMachineParams(params).duration))
			{
				if (tween) tween.end();
				tween = new GTween(this, TFXSlotMachineParams(params).duration);
				tween.setValue("percent", 1);
				tween.onChange = update;
			}
		}

		private function update(tween : GTween = null) : void
		{
			
			tween;
			updateCount = Math.round(this.percent / updateStep);
			var diff : uint = updateCount - (textField.length - tmpLetters.length);
			for (var i : uint = 0; i < diff; i++) finalizeOneLetter();
		}

		private function finalizeOneLetter() : void
		{
			var index : uint = Math.floor(Math.random() * tmpLetters.length);
			if (params != null) Letter(tmpLetters[index]).finalize(TFXSlotMachineParams(params).blobb);
			else Letter(tmpLetters[index]).finalize();

			tmpLetters.splice(index, 1);
		}
	}
}
