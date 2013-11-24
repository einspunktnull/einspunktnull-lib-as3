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
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/** 
	 * KeyButton is a display component representing a key in the Keyboard component.
	 *   
	 * @author Rien Verbrugghe
	 * @mail rien.verbrugghe@nascom.be
	 * 
	 */
	public class KeyButton extends MovieClip 
	{
		public static const PRESSED_SPACEBAR_KEY:String = "spacebar";
		public static const PRESSED_TAB_KEY:String = "tab";
		public static const PRESSED_BACKSPACE_KEY:String = "backspace";
		public static const PRESSED_ENTER_KEY:String = "enter";
		public static const PRESSED_SHIFT_KEY:String = "shift";
		public static const PRESSED_CAPSLOCK_KEY:String = "capslock";
				
		public var keyWidth:uint = 0;
		
		protected var _char:String = "";
		protected var _shiftChar:String = "";
		protected var _keyHeight:uint;
		protected var _keyCorner:uint;
		protected var _keyColor1:uint;
		protected var _keyColor2:uint;
		protected var _textFormat1:TextFormat;
		protected var _textFormat2:TextFormat;
		protected var _lineColor:uint;
		protected var _charTextField:TextField = new TextField;
		protected var _shiftCharTextField:TextField = new TextField;
		protected var _backGround:MovieClip = new MovieClip;
		protected var _keytype:String;
		
		public function KeyButton(type:String, character:String, shiftCharacter:String, keyHeight:uint) 
		{
			this._keytype = type;
			this._keyHeight = keyHeight;
			this._char = character;
			this._shiftChar = shiftCharacter;
			
			addEventListener(MouseEvent.CLICK, clicked);
			addEventListener(MouseEvent.MOUSE_OVER, hover);
			addEventListener(MouseEvent.MOUSE_OUT, leave);
//			addEventListener(Event.ENTER_FRAME, checkStatus);
			addChild(_backGround);
						
			mouseChildren = false;			
		}
				
		public function get keyHeight():uint
		{
			return _keyHeight;
		}
		
		public function build(keyCorner:uint, keyColor1:uint, keyColor2:uint, textFormat1:TextFormat, textFormat2:TextFormat, lineColor:uint):void 
		{
			this._keyCorner = keyCorner;
			this._keyColor1 = keyColor1;
			this._keyColor2 = keyColor2;
			this._textFormat1 = textFormat1;
			this._textFormat2 = textFormat2;
			this._lineColor = lineColor;
		
			defaultState();
			addTextFields();
		}
		
		protected function reDraw(mouseStatus:String = ''):void 
		{
			if(_keytype == PRESSED_SHIFT_KEY) 
			{
				if (KeyboardTouch.shift)
					hoverState();
				else
					defaultState();
			}else if (_keytype == PRESSED_CAPSLOCK_KEY) 
			{
				if (KeyboardTouch.caps)
					hoverState();
				else
					defaultState();
			}else 
			{
				if (mouseStatus == MouseEvent.MOUSE_OVER)
					hoverState();
				else if (mouseStatus == MouseEvent.MOUSE_OUT)
					defaultState();
			}
		}
		
		protected function hoverState():void 
		{			
			_backGround.graphics.clear();
			_backGround.graphics.beginFill(_keyColor1,.7);
			_backGround.graphics.lineStyle(0, _lineColor, 1, true);
			_backGround.graphics.drawRoundRect(0, 0, keyWidth, _keyHeight, _keyCorner, _keyCorner);
			_backGround.graphics.endFill();
		}
		
		protected function defaultState():void 
		{
			_backGround.graphics.clear();
			_backGround.graphics.beginFill(_keyColor2,1);
			_backGround.graphics.lineStyle(0, _lineColor, 1, true);
			_backGround.graphics.drawRoundRect(0, 0, keyWidth, _keyHeight, _keyCorner, _keyCorner);
			_backGround.graphics.endFill();
		}
		
		protected function addTextFields():void 
		{		
			_charTextField.width = keyWidth;
			_charTextField.y = 15;
			_charTextField.htmlText = _char;
			_charTextField.setTextFormat(_textFormat1);
			_charTextField.autoSize = TextFieldAutoSize.CENTER;
			_charTextField.selectable = false;
			_charTextField.mouseEnabled = false;

			_shiftCharTextField.width = keyWidth/2;
			_shiftCharTextField.text = _shiftChar;
			_shiftCharTextField.setTextFormat(_textFormat2);
			_shiftCharTextField.autoSize = TextFieldAutoSize.CENTER;
			_shiftCharTextField.selectable = false;
			_shiftCharTextField.mouseEnabled = false;

			addChild(_charTextField);
			addChild(_shiftCharTextField);
		}
		
		protected function getChar(string:String, shiftString:String):String 
		{
			if (KeyboardTouch.shift) {
				return shiftString;
				KeyboardTouch.shift = false;
			} else if (KeyboardTouch.caps) {
				return shiftString;
			} else {
				return string;
			}
		}
		
		protected function insertText(text:String):void
		{
			var s:String = KeyboardTouch.textfield.text;
			var caretIndex:Number = KeyboardTouch.textfield.caretIndex;
			if(caretIndex==0)
			{
				s = s + text;
				KeyboardTouch.textfield.text = s;
				KeyboardTouch.textfield.setSelection(caretIndex+1,caretIndex+1);
			}else
			{
				s = s.substr(0,caretIndex) + text + s.substr(caretIndex,s.length);
				KeyboardTouch.textfield.text = s;
				KeyboardTouch.textfield.setSelection(caretIndex+1,caretIndex+1);	
			}
		}
		
		protected function deleteText():void
		{
			var s:String = KeyboardTouch.textfield.text;
			var caretIndex:Number = KeyboardTouch.textfield.caretIndex;
			if(caretIndex==0)
			{
				//do nothing, already at the beginning of the textfield
			}else
			{
				s = s.substr(0,caretIndex-1)+s.substr(caretIndex,s.length-caretIndex);
				KeyboardTouch.textfield.text = s;
				KeyboardTouch.textfield.setSelection(caretIndex-1,caretIndex-1);	
			}
		}
		
		protected function clicked(event:MouseEvent):void 
		{
			var s:String = KeyboardTouch.textfield.text;
			var index:Number = KeyboardTouch.textfield.caretIndex;
					
			switch (_keytype) 
			{
				case PRESSED_SPACEBAR_KEY:
					insertText(" ");
					dispatchEvent(new Event(PRESSED_SPACEBAR_KEY, true));
					break;
				case PRESSED_TAB_KEY:
					insertText("\t");
					dispatchEvent(new Event(PRESSED_TAB_KEY, true));
					break;
				case PRESSED_BACKSPACE_KEY:
					deleteText();
					dispatchEvent(new Event(PRESSED_BACKSPACE_KEY, true));
					break;
				case PRESSED_ENTER_KEY:
					insertText("\n");
					dispatchEvent(new Event( PRESSED_ENTER_KEY, true));
					break;
				case PRESSED_SHIFT_KEY:
					KeyboardTouch.shiftToggle();
					dispatchEvent(new Event(PRESSED_SHIFT_KEY, true));
					break;
				case PRESSED_CAPSLOCK_KEY:
					KeyboardTouch.capsToggle();
					KeyboardTouch.shift = false;
					dispatchEvent(new Event(PRESSED_CAPSLOCK_KEY, true));
					reDraw();
					break;
				default :
					insertText(getChar(_char, _shiftChar));
			}
			
			KeyboardTouch.textfield.stage.focus = KeyboardTouch.textfield;
		}
		
		protected function checkStatus(event:Event):void 
		{
			reDraw();
		}
		
		protected function hover(event:MouseEvent):void 
		{
			reDraw(MouseEvent.MOUSE_OVER);
		}
		
		protected function leave(event:MouseEvent):void 
		{
			reDraw(MouseEvent.MOUSE_OUT);
		}
	}
}