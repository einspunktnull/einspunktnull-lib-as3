package net.einspunktnull.typography.fx.slotmachine
{
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Quartic;
	import com.gskinner.motion.plugins.MotionBlurPlugin;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author Albrecht Nitsche
	 */
	public class Letter extends Sprite
	{
		private var character : String;
		private var textFormat : TextFormat;
		private var textField : TextField;

		public function Letter(textField : TextField, index : uint)
		{
			this.textFormat = textField.getTextFormat();
			this.character = textField.text.charAt(index);

			this.textField = new TextField();
			this.textField.selectable = false;
			this.textField.embedFonts = true;
			this.textField.autoSize = TextFieldAutoSize.LEFT;
			this.textField.antiAliasType = AntiAliasType.ADVANCED;
			this.textField.defaultTextFormat = textFormat;
			this.textField.text = character;
			addChild(this.textField);
			this.textField.x = -this.textField.width / 2;
			this.textField.y = -this.textField.height / 2;

			MotionBlurPlugin.install();
			MotionBlurPlugin.strength = 2;

			reset();
		}

		public function reset() : void
		{
			this.filters = [new BlurFilter(0, Number(textFormat.size) * 0.6, 1)];
			addEventListener(Event.ENTER_FRAME, randomize);
		}

		private function randomize(event : Event) : void
		{
			var ran : uint = Math.round((Math.random() * 24) + 33);
			textField.text = String.fromCharCode(ran);
		}

		public function finalize(tweening : Boolean = false) : void
		{
			removeEventListener(Event.ENTER_FRAME, randomize);
			textField.text = character;
			this.filters = null;

			if (tweening)
			{
				this.scaleX = this.scaleY = 0;

				var tween1 : GTween = new GTween(this, 0.25);
				tween1.setValue("scaleX", 2);
				tween1.setValue("scaleY", 2);

				tween1.ease = Quartic.easeIn;
				tween1.pluginData = {MotionBlurEnabled:true};

				var tween2 : GTween = new GTween(this, 0.1);
				tween2.setValue("scaleX", 1);
				tween2.setValue("scaleY", 1);
				tween2.ease = Quartic.easeOut;
				tween2.delay = 0.25;
				tween1.pluginData = {MotionBlurEnabled:true};
			}
		}
	}
}
