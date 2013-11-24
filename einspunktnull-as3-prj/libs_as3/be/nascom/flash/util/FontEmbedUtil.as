/*
Copyright (c) 2008 NascomASLib Contributors.  See:
    http://code.google.com/p/nascomaslib

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
package be.nascom.flash.util
{
	import flash.text.Font;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class FontEmbedUtil
	{
		protected static var _fontList:Array;
		protected static var _fontNames:Array;
		protected static var _debug:Boolean; 
		/** 
		 * FontEmbedUtil is used to dynamically set embedded fonts for any TextField
		 *   
		 * @author Rien Verbrugghe
		 * @mail rien.verbrugghe@nascom.be
		 * 
	 	 */
		public function FontEmbedUtil(debug:Boolean=false)
		{
			_debug = debug;
			_fontList = Font.enumerateFonts();
			_fontNames = [];
			
			if(debug)trace("Embedded fonts to choose from:");
			for( var i:int=0; i<_fontList.length; i++ )
			{
				_fontNames.push(_fontList[ i ].fontName);
				if(debug)trace("#"+i+" fontFamily name: " + _fontNames[i] );
			}
		}
		
		/** 
		 * setFont is used to choose which embedded font the texfield may use to render. 
		 * If it's not available it will throw an error.
		 * NOTE: when using htmlText in your textfield, call this function AFTER having changed the htmlText!
		 * 
	 	 */
		public static function setFont(textField:TextField, fontFamilyName:String):void
		{						
			textField.embedFonts = true;
			textField.x = Math.round(textField.x);//it's always better to have rounded positions
			textField.y = Math.round(textField.y);//it's always better to have rounded positions
			
			var currentTextFormat:TextFormat = textField.getTextFormat();
			currentTextFormat.font = getFontNameIfEmbedded(fontFamilyName);
			
			if(_debug){
//				textField.rotation = 2;//to check if they are actually embedded
				currentTextFormat.color = 0xff0000;
			}
				
			apply(textField,currentTextFormat);
		}
		
		/** 
		 * setFormat is used to choose colors, leading, cursive etc. for your textfield.
		 * setting all format features BUT skips setting the font...use setFont for that.
		 * NOTE: when using htmlText in your textfield, call this function AFTER having changed the htmlText!
		 * 
	 	 */
		public static function setFormat(textField:TextField, newTextFormat:TextFormat):void
		{
			var currentTextFormat:TextFormat = textField.getTextFormat();			
			currentTextFormat.align = newTextFormat.align;
			currentTextFormat.blockIndent = newTextFormat.blockIndent;
			currentTextFormat.bold = newTextFormat.bold;
			currentTextFormat.bullet = newTextFormat.bullet;
			currentTextFormat.color = newTextFormat.color;
			currentTextFormat.indent = newTextFormat.indent;
			currentTextFormat.italic = newTextFormat.italic;
			currentTextFormat.kerning = newTextFormat.kerning;
			currentTextFormat.leading = newTextFormat.leading;
			currentTextFormat.leftMargin = newTextFormat.leftMargin;
			currentTextFormat.letterSpacing = newTextFormat.letterSpacing;
			currentTextFormat.rightMargin = newTextFormat.rightMargin;
			currentTextFormat.size = newTextFormat.size;
			currentTextFormat.tabStops = newTextFormat.tabStops;
			currentTextFormat.target = newTextFormat.target;
			currentTextFormat.underline = newTextFormat.underline;
			currentTextFormat.url = newTextFormat.url;

			apply(textField,currentTextFormat);
		}
		
		/** 
		 * setCss is used to set CSS on the textfield and to check if you used embedded fonts in all the styles.
		 * NOTE: when using htmlText in your textfield, call this function AFTER having changed the htmlText!
		 * 
	 	 */
		public static function setCss(textField:TextField, styleSheet:StyleSheet):void
		{
			var styleObject:Object;
			for( var i:int=0; i<styleSheet.styleNames.length; i++ )
			{
				styleObject = styleSheet.getStyle(styleSheet.styleNames[i]);
				if(styleObject.hasOwnProperty("fontFamily"))
					getFontNameIfEmbedded(styleObject.fontFamily);
			}
			textField.styleSheet = styleSheet;
		}
		
		/** 
		 * fitToSize is used to fit all text within the textfield and decrease the font size as such.
		 *  
	 	 */
		public static function fitToSize(textField:TextField, maxWidth:Number=-1, maxHeight:Number=-1):void 
		{
			var maxTextWidth : int = maxWidth > 0 ? maxWidth : textField.width;
			var maxTextHeight : int = maxHeight > 0 ? maxHeight : textField.height;
			var f:TextFormat = textField.getTextFormat();

			while(textField.textWidth > maxTextWidth || textField.textHeight > maxTextHeight) 
			{
				f.size = int(f.size) - 1;
				textField.setTextFormat(f);
			}
		}
		
		protected static function apply(textField:TextField, textFormat:TextFormat):void
		{
			textField.defaultTextFormat = textFormat;
			textField.setTextFormat(textFormat);
		}
		
		protected static function getFontNameIfEmbedded(fontFamilyName:String):String
		{
			for( var i:int=0; i<_fontList.length; i++ )
			{
				if(_fontNames[i]==fontFamilyName)
					return fontFamilyName;
			}
			throw new Error("Trying to set font '" + fontFamilyName + "' which was never embedded in the current SWF. Only the following fonts are embedded: " + _fontNames.toString());
			return null;
		}
	}
}