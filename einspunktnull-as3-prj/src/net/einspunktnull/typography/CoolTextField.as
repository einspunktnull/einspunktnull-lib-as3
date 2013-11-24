package net.einspunktnull.typography
{
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author Albrecht Nitsche
	 */
	public class CoolTextField extends TextField
	{
		private var _textFormat : TextFormat = new TextFormat();
		private var defaultStyle : Object;
		private var style : StyleSheet;


		public function CoolTextField(fontFamily : String)
		{

			defaultStyle = new Object();
			defaultStyle["fontFamily"] = fontFamily;

			style = new StyleSheet();
			style.setStyle(".defaultStyle", defaultStyle);

			_textFormat.color = 0x000000;
			_textFormat.size = 11;

			textFormat = _textFormat;
		}

		public function get textFormat() : TextFormat
		{
			return _textFormat;
		}

		public function set textFormat(textFormat : TextFormat) : void
		{
			_textFormat = textFormat;
			this.defaultTextFormat = _textFormat;
			this.embedFonts = true;
			this.styleSheet = style;
		}

		override public function set htmlText(string : String) : void
		{
			super.htmlText = "<span class='defaultStyle'>" + string + "</span>";
		}

		public function set color(value : uint) : void
		{
			this.styleSheet = null;
			var textFormat : TextFormat = _textFormat;
			textFormat.color = value;
			this.textFormat = textFormat;
		}

		public function set fontSize(value : Number) : void
		{
			this.styleSheet = null;
			var textFormat : TextFormat = _textFormat;
			textFormat.size = value;
			this.textFormat = textFormat;
		}

		public function set leading(value : Number) : void
		{
			this.styleSheet = null;
			var textFormat : TextFormat = _textFormat;
			textFormat.leading = value;
			this.textFormat = textFormat;
		}
	}
}
