package net.einspunktnull.typography.fx
{
	import net.einspunktnull.data.util.ObjectUtil;

	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * @author Albrecht Nitsche
	 */
	public class TFX extends Sprite
	{
		protected var textField : TextField;
		public var params : ITFXParams;

		public function TFX(textField : TextField, params:ITFXParams = null)
		{
			this.params = params;
			this.textField = TextField(ObjectUtil.clone(textField));
		}
	}
}
