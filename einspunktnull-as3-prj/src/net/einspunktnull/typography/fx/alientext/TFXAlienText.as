package net.einspunktnull.typography.fx.alientext
{
	import flash.events.Event;

	import net.einspunktnull.typography.fx.ITFX;
	import net.einspunktnull.typography.fx.ITFXParams;
	import net.einspunktnull.typography.fx.TFX;

	import flash.text.TextField;

	/**
	 * @author Albrecht Nitsche
	 */
	public class TFXAlienText extends TFX implements ITFX
	{
		private var text : String;
		private var cFrame : uint;
		private var cFramesTotal : uint;
		private var index : uint;

		public function TFXAlienText(textField : TextField, params : ITFXParams = null)
		{
			if (params == null) params = new TFXAlienTextParams();
			super(textField, params);
			text = textField.text;
			addChild(this.textField);
		}

		public function start() : void
		{
			reset();
			play();
		}

		private function reset() : void
		{
			if (hasEventListener(Event.ENTER_FRAME)) removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			cFrame = 0;
			index = 0;
			textField.text = text;
		}

		private function play() : void
		{
			cFramesTotal = Math.round(TFXAlienTextParams(params).duration * stage.frameRate);
			
			if (!hasEventListener(Event.ENTER_FRAME)) addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(event : Event) : void
		{
			var ratio : Number = cFrame / cFramesTotal;
			index = Math.floor(ratio * text.length);

			var txtTmp : String = "";
			for (var i : uint = 0; i < text.length; i++)
			{
				if (i <= index) txtTmp += text.charAt(i);
				else txtTmp += String.fromCharCode(Math.round((Math.random() * 24) + 33));
			}

			textField.text = txtTmp;
			cFrame++;
			if (cFrame >= cFramesTotal) reset();
		}
	}
}
