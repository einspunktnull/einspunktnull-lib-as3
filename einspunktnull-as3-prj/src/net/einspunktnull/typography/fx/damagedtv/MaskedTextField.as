package net.einspunktnull.typography.fx.damagedtv
{
	import net.einspunktnull.data.util.ObjectUtil;

	import com.gskinner.motion.GTween;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * @author Albrecht Nitsche
	 */
	public class MaskedTextField extends Sprite
	{
		private var textField : TextField;
		private var maskShape : Shape;
		public var refX : Number;
		public var tween : GTween;

		public function MaskedTextField(textField : TextField, refX : Number, y : Number, height : Number)
		{
			this.refX = refX;
			this.textField = TextField(ObjectUtil.clone(textField));
			addChild(this.textField);

			maskShape = new Shape();
			maskShape.graphics.beginFill(0xff0000);
			maskShape.graphics.drawRect(0, y, textField.width, height);
			maskShape.graphics.endFill();
			addChild(maskShape);

			this.textField.mask = maskShape;
		}
	}
}
