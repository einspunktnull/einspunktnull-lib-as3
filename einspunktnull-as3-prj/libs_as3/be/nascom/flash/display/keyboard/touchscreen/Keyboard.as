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

package be.nascom.flash.display.keyboard.touchscreen
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	/** 
	 * Keyboard (version 2) is a display component representing a keyboard based on a XML.
	 * Te provided textfield will not support HTML, only plain text. And should be single line.
	 * 
	 * @example The following code will create a textfield and a keyboard. The XML document should be loaded and passed to the contructor of the keyboard.
	 * <listing version="3.0">
	 * 		var textfield = new TextField();
	 * 		textfield.type = TextFieldType.INPUT;
	 * 		addChild(textfield);
	 * 		
	 * 		var keyboard = new Keyboard(xml, new TextFormat("Arial", 14, 0x000000), new TextFormat("Arial", 10, 0x666666));
	 * 		keyboard.inputField = textfield;
	 * 		addChild(keyboard);
	 * </listing>
	 *   
	 * @author Geert Bollen
	 * @mail geert.bollen@nascom.be
	 * 
	 */
	public class Keyboard extends MovieClip 
	{			
		private var _shift:Boolean = false;
		private var _shiftSpecialChars:Boolean = false;
		private var _caps:Boolean = false;
		
		private var _textField:TextField;
		private var _keysData:XML;
		private var _keysHolder:Sprite;
		private var _keysLongPressHolder:Sprite;
		private var _keysSpecialCharsHolder:Sprite;
		private var _shiftKeys:Array;
		private var _capsLockKey:Key;
		private var _keyboard:String = "default";
		private var _symbols:Array;
		private var _backgrounds:Array;
		
		private var _textFormatChar:TextFormat; 
		private var _textFormatShiftChar:TextFormat;
		private var _keyWidth:Number;
		private var _margin:Number;
		private var _keyCorner:uint;
		private var _keyColorDefault:uint;
		private var _keyColorMouseDown:uint;
		private var _keyColorMouseOver:uint;
		private var _keyLineColor:uint;
		
		public function Keyboard(xmlKeyboardLayout:XML,
									textFormatChar:TextFormat, 
									textFormatShiftChar:TextFormat, 
									keyWidth:Number=50, 
									margin:Number=5, 
									keyCorner:uint=10, 
									keyColorDefault:uint=0xffffff,
									keyColorMouseOver:uint=0xcccccc, 
									keyColorMouseDown:uint=0x666666, 
									keyLineColor:uint=0x000000) 
		{
			_keysData = xmlKeyboardLayout;
			_textFormatChar = textFormatChar;
			_textFormatShiftChar = textFormatShiftChar;
			_keyWidth = keyWidth;
			_margin = margin;
			_keyCorner = keyCorner;
			_keyColorDefault = keyColorDefault;
			_keyColorMouseDown = keyColorMouseDown;
			_keyColorMouseOver = keyColorMouseOver;
			_keyLineColor = keyLineColor;
			
			this._shiftKeys = new Array();
			this._keysHolder = new Sprite();
			this._keysLongPressHolder = new Sprite();
			this._keysSpecialCharsHolder = new Sprite();
			this._symbols = new Array();
			this._backgrounds = new Array();
			
			this.addChild(this._keysHolder);
			this.addChild(this._keysLongPressHolder);
//			this.addChild(this._keysSpecialCharsHolder);
			
			this.init(this._keyboard);
		}
		
		private function init(keyboard:String):void
		{
			var key:Key;
			
			this._keyboard = keyboard;
			this._shift = false;
			this._caps = false;
			
			this.resetKeyHolder();
			this.resetLongPressKeyHolder();
			this.resetSpecialCharsHolder();
			this.buildKeyboard();
			
			for(var i:uint=0; i<this._symbols.length; i++)
			{
				key = this._keysHolder.getChildByName(this._symbols[i].keyID) as Key;
				if(key!=null) key.setSymbol(this._symbols[i].symbol);
			}
		}
		private function resetKeyHolder():void 
		{
			while(this._keysHolder.numChildren>0)
				this._keysHolder.removeChildAt(0);
		}
		private function resetLongPressKeyHolder():void
		{
			this._keysLongPressHolder.visible = false;
			
			while(this._keysLongPressHolder.numChildren>0)
				this._keysLongPressHolder.removeChildAt(0);
		}
		private function resetSpecialCharsHolder():void
		{
			this._keysSpecialCharsHolder.visible = false;
			
			while(this._keysSpecialCharsHolder.numChildren>0)
				this._keysSpecialCharsHolder.removeChildAt(0);
		}
		
		private function buildKeyboard():void 
		{			
			var numKeys:Number = getNumberOfKeys();
			var key:Key;
			var xPlacement:Number = 0;
			var longPressKeys:Sprite;
			var specialCharsKeys:Sprite;
			var showShiftChar:Boolean = false;
			var n:uint = 0;
			
			for (var i:int = 0; i < _keysData[_keyboard].row.length(); i++) 
			{
				for each(var keyDoc:XML in XML(_keysData[_keyboard].row[i]).children())
				{
					if(keyDoc.shift.@visible=="true")
						showShiftChar = true;
					
					key = new Key(keyDoc.name(), keyDoc.char, keyDoc.shift, checkWidth(keyDoc.char, keyDoc.@scale), _keyWidth, _keyCorner, _keyColorDefault, _keyColorMouseOver, _keyColorMouseDown, _keyLineColor, _textFormatChar, _textFormatShiftChar, showShiftChar);
					key.addEventListener(KeyEvent.PRESSED, onPress);
					key.addEventListener(KeyEvent.LONG_PRESS, onLongPress);
					key.x = xPlacement + _margin;
					key.y = (key.keyHeight + _margin) * i;
					
					if(keyDoc.@id!="")
						key.name = keyDoc.@id;
					else
						key.name = "key"+n.toString();
					
					if(keyDoc.longpress.length()>0)
					{
						longPressKeys = new Sprite();
						this.buildLongPressKeys(keyDoc, longPressKeys);
						key.longPressKeys = longPressKeys;
					}
					if(keyDoc.specialchars.length()>0)
					{
						specialCharsKeys = new Sprite();
						this.buildSpecialCharsKeys(keyDoc, specialCharsKeys);
						key.specialCharsKeys = specialCharsKeys;
					}
					
					this._keysHolder.addChild(key);
					
					if(keyDoc.name()==KeyName.SHIFT_KEY && keyDoc.char!="")
					{
						this._shiftKeys.push(key);
					}
					else if(keyDoc.name()==KeyName.CAPSLOCK_KEY)
					{
						this._capsLockKey = key;
					}
					else if(keyDoc.name()==KeyName.KEYBOARD_KEY)
					{
						key.keyboardName = keyDoc.@name;
					}
					
					xPlacement += key.keyWidth + _margin;
					showShiftChar = false;
					n++;
				}
				xPlacement = 0;
			}			
			
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		// the popup at the pressed key, with extra characters
		private function buildLongPressKeys(xmlDoc:XML, holder:Sprite):void
		{
			var key:Key;
			var xPlacement:Number = 0;
			var background:Sprite;
			var backgroundWidth:Number;
			var backgroundHeight:Number;
			
			backgroundWidth = (xmlDoc.longpress.children().length()*_keyWidth)+(_margin*(xmlDoc.longpress.children().length()+1));
			backgroundHeight = _keyWidth+(_margin*2);
			background = new Sprite();
			background.graphics.beginFill(_keyColorDefault, 1);
			background.graphics.lineStyle(0, _keyLineColor, 1, true);
			background.graphics.drawRoundRect(0, 0, backgroundWidth, backgroundHeight, _keyCorner, _keyCorner);
			background.graphics.endFill();
			background.x = 0;
			background.y = -_margin;
			holder.addChild(background);
			
			for each(var keyDoc:XML in xmlDoc.longpress.children())
			{
				key = new Key("key", keyDoc.char, keyDoc.shift, _keyWidth, _keyWidth, _keyCorner, _keyColorDefault, _keyColorMouseOver, _keyColorMouseDown, _keyLineColor, _textFormatChar, _textFormatShiftChar);
				key.addEventListener(KeyEvent.PRESSED, onPress);
				key.x = xPlacement + _margin;
				holder.addChild(key);
				
				xPlacement += key.keyWidth + _margin;
			}
		}
		// the popup on top of the textfield, with extra characters 
		private function buildSpecialCharsKeys(xmlDoc:XML, holder:Sprite):void
		{
			var key:Key;
			var xPlacement:Number = 0;
			var background:Sprite;
			var backgroundShape:Shape;
			var backgroundWidth:Number;
			var backgroundHeight:Number;
			var triangle:Shape;
			
			backgroundWidth = (xmlDoc.specialchars.children().length()*_keyWidth)+(_margin*(xmlDoc.specialchars.children().length()+1));
			backgroundHeight = _keyWidth+(_margin*2);
			background = new Sprite();
			
			backgroundShape = new Shape();
			backgroundShape.graphics.beginFill(_keyColorDefault, 1);
			backgroundShape.graphics.lineStyle(0, _keyLineColor, 1, true);
			backgroundShape.graphics.drawRoundRect(0, 0, backgroundWidth, backgroundHeight, _keyCorner, _keyCorner);
			backgroundShape.graphics.endFill();
			backgroundShape.x = 0;
			backgroundShape.y = -_margin;
			
			triangle = new Shape();
			triangle.graphics.beginFill(_keyColorDefault, 1);
			triangle.graphics.lineStyle(0, _keyLineColor, 1, true);
			triangle.graphics.lineTo(_margin*3, 0);
			triangle.graphics.lineTo(_margin*1.5, _margin*3);
			triangle.graphics.lineTo(0, 0);
			triangle.x = _margin*2;
			triangle.y = _keyWidth + _margin;
			
			background.addChild(triangle);
			background.addChild(backgroundShape);
			holder.addChild(background);
			
			for each(var keyDoc:XML in xmlDoc.specialchars.children())
			{
				key = new Key("key", keyDoc.char, keyDoc.shift, _keyWidth, _keyWidth, _keyCorner, _keyColorDefault, _keyColorMouseOver, _keyColorMouseDown, _keyLineColor, _textFormatChar, _textFormatShiftChar);
				key.addEventListener(KeyEvent.PRESSED, onPressSpecialChar);
				key.x = xPlacement + _margin;
				holder.addChild(key);
				
				xPlacement += key.keyWidth + _margin;
			}
		}
		private function checkWidth(code:String, scale:Number):Number 
		{	
			return ((scale*_keyWidth)+(_margin*(scale-1)));
		}
		private function getNumberOfKeys():Number 
		{
			var keyCounter:Number = 0;
			for (var i:int = 0; i < _keysData[_keyboard].row.length(); i++) {
				keyCounter += _keysData[_keyboard].row[i].key.length();
			}
			return keyCounter;
		}
		
		private function onLongPress(e:KeyEvent):void
		{
			var key:Key;
			
			this._keysSpecialCharsHolder.visible = false;
			
			key = Key(e.target);
			
			while(this._keysLongPressHolder.numChildren>0)
				this._keysLongPressHolder.removeChildAt(0);
			
			if(Key(e.target).longPressKeys!=null)
			{
				this._keysLongPressHolder.addChild(key.longPressKeys);
				this._keysLongPressHolder.visible = true;
				this._keysLongPressHolder.x = key.x + _keyWidth*0.7;
				this._keysLongPressHolder.y = key.y - _keyWidth*0.7;
			}
		}
		private function onPressSpecialChar(e:KeyEvent):void
		{
			var inputCharacter:String;
			
			if(this._shiftSpecialChars)
			{
				inputCharacter = e.shiftCharacter;
				if(!this._caps)
				{
					this.disableShift();
					this._shiftSpecialChars = false;
				}
			} 
			else
			{
				inputCharacter = e.character;
			}
			this.deleteText();
			this.insertText(inputCharacter);
			
			this._keysSpecialCharsHolder.visible = false;
		}
		private function onPress(e:KeyEvent):void
		{
			var inputCharacter:String;
			
			this._keysLongPressHolder.visible = false;
			this._keysSpecialCharsHolder.visible = false;
			
			switch(e.key)
			{
				case KeyName.KEYBOARD_KEY:
					this.init(Key(e.target).keyboardName);
				break;
				
				case KeyName.SPACEBAR_KEY:
					this.insertText(e.character);
				break;
				
				case KeyName.TAB_KEY:
					this.insertText(e.character);
					this.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 9, 9));
				break;
				
				case KeyName.ENTER_KEY:
					this.insertText(e.character);
					this.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 13, 13));
				break;
				
				case KeyName.BACKSPACE_KEY:
					this.deleteText();
				break;
				
				case KeyName.SHIFT_KEY:
					this.toggleShift();
				break;
				
				case KeyName.CAPSLOCK_KEY:
					this.toggleCaps();
				break;
				
				default:
					if(this._shift)
					{
						inputCharacter = e.shiftCharacter;
						this.toggleShift();
						this.disableShift();
					} 
					else if(this._caps)
					{
						inputCharacter = e.shiftCharacter;
					}
					else
					{
						inputCharacter = e.character;
					}
					
					if(Key(e.target).specialCharsKeys!=null)
						this.showSpecialCharsKeys(Key(e.target));
					
					this.insertText(inputCharacter);
			}
			
			this._textField.stage.focus = this._textField;
		}
		
		private function showSpecialCharsKeys(key:Key):void
		{
			while(this._keysSpecialCharsHolder.numChildren>0)
				this._keysSpecialCharsHolder.removeChildAt(0);
			
			if(this._shiftSpecialChars)
				key.shiftSpecialChars();
			else if(!this._caps)
				key.unshiftSpecialChars();
			
			this._keysSpecialCharsHolder.addChild(key.specialCharsKeys);
			this._keysSpecialCharsHolder.visible = true;
//			this._keysSpecialCharsHolder.x = -(this.x - this._textField.x) + this.getInputTextfieldWidth() - this._margin*2;
//			this._keysSpecialCharsHolder.y = -(this.y - this._textField.y) - this._keysSpecialCharsHolder.height - this._margin;
			this._keysSpecialCharsHolder.x = this._textField.x + this.getInputTextfieldWidth() - this._margin*2;
			this._keysSpecialCharsHolder.y = this._textField.y - this._keysSpecialCharsHolder.height - this._margin;
		}
		// where to display the special characters popup
		private function getInputTextfieldWidth():Number
		{
			var tf:TextField;
			var output:Number;
			
			tf = new TextField();
			tf.type = TextFieldType.DYNAMIC;
			tf.defaultTextFormat = this._textField.getTextFormat();
			tf.width = this._textField.width;
			tf.height = this._textField.height;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.text = this._textField.text;
			output = tf.width;
			tf = null;
			if(output>_textField.width-10) output = _textField.width-10;
			
			return output;
		}
		
		private function insertText(inputText:String):void
		{
			var text:String = this._textField.text;
			var caretIndex:Number = this._textField.caretIndex;
			
//			if(caretIndex==0)
//			{
//				text = text + inputText;
//				this._textField.text = text;
//				this._textField.setSelection(caretIndex+1, caretIndex+1);
//			}
//			else
//			{
				text = text.substr(0, caretIndex) + inputText + text.substr(caretIndex, text.length);
				this._textField.text = text;
				this._textField.setSelection(caretIndex+1, caretIndex+1);	
//			}
		}
		private function deleteText():void
		{
			var text:String = this._textField.text;
			var caretIndex:Number = this._textField.caretIndex;
			
			if(caretIndex!=0)
			{
				text = text.substr(0, caretIndex-1) + text.substr(caretIndex, text.length-caretIndex);
				this._textField.text = text;
				this._textField.setSelection(caretIndex-1, caretIndex-1);	
			}
		}
		
		private function toggleCaps():void 
		{
			var key:Key;
			
			if (this._caps)
			{
				this._caps = false;
				this._shiftSpecialChars = false;
			}
			else
			{
				this._caps = true;
				this._shiftSpecialChars = true;
			}
			
			if (this._shift)
			{
				this.toggleShift();
				this.disableShift();
			}
			
			for(var i:uint=0; i<this._keysHolder.numChildren; i++)
			{
				key = this._keysHolder.getChildAt(i) as Key;
				if (this._caps)
				{
					key.shift();
					key.shiftSpecialChars();
				}
				else
				{
					key.unshift();
					key.unshiftSpecialChars();
				}
			}
		}
		private function toggleShift():void 
		{
			var key:Key;
			
			if (this._shift)
				this._shift = false;
			else 
			{	
				this._shift = true;
				this._shiftSpecialChars = true;
			}
			
			if (this._caps)
				this.capsRelease();
			
			for(var i:uint=0; i<this._keysHolder.numChildren; i++)
			{
				key = this._keysHolder.getChildAt(i) as Key;
				if (this._shift)
					key.shift();
				else
					key.unshift();
			}
		}
		// will set the shift key (all of them if many) to default state
		private function disableShift():void
		{
			var shiftKey:Key;
			
			for(var i:uint=0; i<this._shiftKeys.length; i++)
			{
				shiftKey = this._shiftKeys[i];
				shiftKey.disableShift();
			}
		}
		private function capsRelease():void
		{
			this._caps = false;
			this._capsLockKey.disableShift();
		}
		
		public function get inputField():TextField
		{
			return this._textField;
		}
		public function set inputField(value:TextField):void 
		{			
			this._textField = value;
			this._textField.parent.addChild(this._keysSpecialCharsHolder);
		}
		
		/**
		 * Add a symbol to a key instead of character text.
		 * 
		 * @param keyID: the ID provided in the XML node <key id="someIdentifier">...</key>
		 * @param symbol: the DisplayObject needs a registration point in the center, and will be centered in the key
		*/
		public function setSymbol(keyID:String, symbol:DisplayObject):void
		{
			var key:Key;
			
			key = this._keysHolder.getChildByName(keyID) as Key;
			key.setSymbol(symbol);
			
			this._symbols.push({keyID:keyID, symbol:symbol});
		}
	}
}