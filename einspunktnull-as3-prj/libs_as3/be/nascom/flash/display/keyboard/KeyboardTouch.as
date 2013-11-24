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
package be.nascom.flash.display.keyboard
{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/** 
	 * Keyboard is a display component representing a keyboard based on a XML.
	 *   
	 * @author Rien Verbrugghe
	 * @mail rien.verbrugghe@nascom.be
	 * 
	 */
	public class KeyboardTouch extends MovieClip 
	{			
		public static const KEYBOARD_IS_READY:String = "keyboard_is_ready";
		
		public static var textfield:TextField;
		public static var shift:Boolean = false;
		public static var caps:Boolean = false;
		
		private static var _keyWidth:Number;
		private static var _keyCorner:uint;
		private static var _keyColor1:uint;
		private static var _keyColor2:uint;
		private static var _textFormat1:TextFormat; 
		private static var _textFormat2:TextFormat;
		private static var _lineColor:uint;				
		private static var _margin:Number;
		private static var keyData:XML = new XML;
		private static var keyHolder:MovieClip = new MovieClip;
		
		public function KeyboardTouch(xmlKeyboardLayout:String,
												textFormat1:TextFormat, 
												textFormat2:TextFormat, 
												keyWidth:Number=35, 
												margin:Number = 2, 
												keyCorner:uint=5, 
												keyColor1:uint=0xcccccc, 
												keyColor2:uint=0xffffff,
												lineColor:uint=0x000000) 
		{
			_margin = margin;
			_keyWidth = keyWidth;
			_keyCorner = keyCorner;
			_keyColor1 = keyColor1;
			_keyColor2 = keyColor2;
			_textFormat1 = textFormat1;
			_textFormat2 = textFormat2;
			_lineColor = lineColor;
			
			loadKeyboardinfo(xmlKeyboardLayout);
			setupKeyHolder();
		}
		
		public function set inputField(value:TextField):void 
		{			
			textfield = value;
		}
		
		static public function capsToggle():void 
		{
			if (caps)
				caps = false;
			else
				caps = true;
		}
		
		static public function shiftToggle():void 
		{
			if (shift)
				shift = false;
			else 
				shift = true;
			
			if(caps)
				caps = false;
		}
		
		protected function loadKeyboardinfo(xmlKeyboardLayout:String):void 
		{
			var xmlLoader:URLLoader = new URLLoader;
			var xmlRequester:URLRequest = new URLRequest(xmlKeyboardLayout);
			xmlLoader.addEventListener(Event.COMPLETE,xmlLoaded);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			xmlLoader.load(xmlRequester);
		}
		
		protected function ioErrorHandler(event:IOErrorEvent):void 
		{
			dispatchEvent(event);
		}
		
		protected function xmlLoaded(event:Event):void 
		{
			var loader:URLLoader=URLLoader(event.target);
			keyData = new XML(loader.data);
			buildKeyboard();
		}
		
		protected function setupKeyHolder():void 
		{
			keyHolder.y = _margin;
			addChild(keyHolder);
		}
		
		protected function buildKeyboard():void 
		{			
			var numKeys:Number = getNumberOfKeys();
			var xPlacement:Number = 0;
			var j:int=0;
			for (var i:int = 0; i < keyData.row.length(); i++) 
			{
				j=0;
				for each(var key:XML in XML(keyData.row[i]).children())
				{
					var newKey:KeyButton = new KeyButton(key.name(), key.char, key.shiftChar, _keyWidth);
					newKey.name = "KeyButton"+i+""+j;
					newKey.keyWidth = checkWidth(key.char, key.scale);
					newKey.x = xPlacement + _margin;
					newKey.y = (newKey.keyHeight + _margin) * i;
					newKey.build(_keyCorner, _keyColor1, _keyColor2, _textFormat1, _textFormat2, _lineColor);
					xPlacement += newKey.keyWidth+ _margin;
					keyHolder.addChild(newKey);
					
					j++;
				}
				xPlacement = 0;
			}			
			dispatchEvent(new Event(KEYBOARD_IS_READY));
		}
		
		protected function checkWidth(code:String, scale:Number):Number 
		{	
			return ((scale*_keyWidth)+(_margin*(scale-1)));
		}
		
		protected function getNumberOfKeys():Number 
		{
			var keyCounter:Number = 0;
			for (var i:int = 0; i < keyData.row.length(); i++) {
				keyCounter += keyData.row[i].key.length();
			}
			return keyCounter;
		}
	}
}