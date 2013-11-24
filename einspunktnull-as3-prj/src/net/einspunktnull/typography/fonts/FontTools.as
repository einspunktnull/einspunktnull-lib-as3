package net.einspunktnull.typography.fonts 
{
	import net.einspunktnull.typography.CoolTextField;

	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author Albrecht Nitsche
	 */
	public class FontTools 
	{
		public static function textField2CoolTextField(inTF:TextField,fontName:String):CoolTextField
		{
			var inFormat:TextFormat = inTF.getTextFormat();
			var outTF:CoolTextField = new CoolTextField(fontName);
			
			outTF.antiAliasType = inTF.antiAliasType;			outTF.width = inTF.width;			outTF.height = inTF.height;
			outTF.x = inTF.x;			outTF.y = inTF.y;
			
			outTF.color = uint(inFormat.color);			outTF.fontSize = Number(inFormat.size);
			outTF.leading = Number(inFormat.leading);
			outTF.selectable = inTF.selectable;
			inTF.parent.addChild(outTF);
			inTF.parent.removeChild(inTF);
			inTF = null;
			return outTF;
		}
	}
}
