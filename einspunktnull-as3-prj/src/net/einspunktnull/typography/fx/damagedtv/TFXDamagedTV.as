package net.einspunktnull.typography.fx.damagedtv
{
	import com.gskinner.motion.GTween;

	import net.einspunktnull.typography.fx.ITFX;
	import net.einspunktnull.typography.fx.TFX;

	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * @author Albrecht Nitsche
	 */
	public class TFXDamagedTV extends TFX implements ITFX
	{
		private var maskedFields : Array = new Array();
		private var isPlaying : Boolean = false;
		private var containerTF : Sprite = new Sprite();
		private var containerMaskTF : Sprite = new Sprite();

		public function TFXDamagedTV(textField : TextField, params : TFXDamagedTVParams = null)
		{
			if (params == null) params = new TFXDamagedTVParams();
			super(textField, params);
			addChild(containerTF);
			containerTF.addChild(this.textField);
			addChild(containerMaskTF);
			containerMaskTF.visible = false;
			createTextFields();
		}

		private function createTextFields() : void
		{
			var height : Number = textField.height / TFXDamagedTVParams(params).divisions;
			for (var i : uint = 0; i < TFXDamagedTVParams(params).divisions; i++)
			{
				var y : Number = i * height;
				var refX : Number = (Math.random() - 0.5) * TFXDamagedTVParams(params).strength * 2;
				var maskedTextField : MaskedTextField = new MaskedTextField(textField, refX, y, height);
				maskedTextField.x = -maskedTextField.refX;
				containerMaskTF.addChild(maskedTextField);
				maskedFields.push(maskedTextField);
			}
		}

		public function start() : void
		{
			if (!isPlaying)
			{
				containerTF.visible = false;
				containerMaskTF.visible = true;
				for each (var maskedTextField1 : MaskedTextField in maskedFields)
				{
					if (stage)
					{
						if (maskedTextField1.tween == null) createTween(maskedTextField1);
						else maskedTextField1.tween.paused = false;
					}
				}
				isPlaying = true;
			}
			else
			{
				containerTF.visible = true;
				containerMaskTF.visible = false;
				for each (var maskedTextField2 : MaskedTextField in maskedFields)
				{
					maskedTextField2.tween.paused = true;
					maskedTextField2.x = -maskedTextField2.refX;
				}
				isPlaying = false;
			}
		}

		private function createTween(maskedTextField : MaskedTextField) : void
		{
			maskedTextField.tween = new GTween(maskedTextField, (TFXDamagedTVParams(params).speed - TFXDamagedTVParams(params).speed / 3) * Math.random() + TFXDamagedTVParams(params).speed / 3);
			maskedTextField.tween.reflect = true;
			maskedTextField.tween.repeatCount = 0;
			maskedTextField.tween.setValue("x", maskedTextField.refX);
		}
	}
}
