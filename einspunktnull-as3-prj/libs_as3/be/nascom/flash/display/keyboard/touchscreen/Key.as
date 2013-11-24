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
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;

	/** 
	 * Key is a display component representing a key button in the Keyboard component.
	 *   
	 * @author Geert Bollen
	 * @mail geert.bollen@nascom.be
	 * 
	 */
	public class Key extends Sprite 
	{
		private var _type:String;
		private var _character:String = "";
		private var _shiftCharacter:String = "";
		private var _keyWidth:Number;
		private var _keyHeight:Number;
		private var _keyCorner:uint;
		private var _keyColorDefault:uint;
		private var _keyColorMouseOver:uint;
		private var _keyColorMouseDown:uint;
		private var _keyLineColor:uint;
		private var _textFormatChar:TextFormat;
		private var _textFormatShiftChar:TextFormat;
		private var _showShiftChar:Boolean;
		
		private var _backGround:Sprite;
		private var _charTextField:TextField;
		private var _shiftCharTextField:TextField;
		private var _enabled:Boolean;
		private var _longPressTimer:Timer;
		private var _longPressKeys:Sprite;
		private var _longPressed:Boolean;
		private var _specialCharsKeys:Sprite;
		private var _keyboard:String;
		
		public function Key(type:String, 
								character:String, 
								shiftCharacter:String, 
								keyWidth:Number, 
								keyHeight:Number,
								keyCorner:uint,
								keyColorDefault:uint, 
								keyColorMouseOver:uint, 
								keyColorMouseDown:uint,
								keyLineColor:uint, 
								textFormatChar:TextFormat, 
								textFormatShiftChar:TextFormat, 
								showShiftChar:Boolean=false
								) 
		{
			this._type = type;
			this._character = character;
			this._shiftCharacter = shiftCharacter;
			this._keyWidth = keyWidth;
			this._keyHeight = keyHeight;
			this._keyCorner = keyCorner;
			this._keyColorDefault = keyColorDefault;
			this._keyColorMouseOver = keyColorMouseOver;
			this._keyColorMouseDown = keyColorMouseDown;
			this._keyLineColor = keyLineColor;
			this._textFormatChar = textFormatChar;
			this._textFormatShiftChar = textFormatShiftChar;
			this._showShiftChar = showShiftChar;
			
			if(character!="")
			{
				this.buttonMode = true;
				this.mouseChildren = false;
				this.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
				this.addEventListener(MouseEvent.MOUSE_UP, onUp);
				this.addEventListener(MouseEvent.MOUSE_OVER, onOver);
				this.addEventListener(MouseEvent.MOUSE_OUT, onOut);
				
				this._backGround = new Sprite();
				this.addChild(_backGround);
				
				this.setDefaultState();
				this.addTextFields();
			}
			
			this._longPressTimer = new Timer(0);
			this._enabled = false;
			this._longPressed = false;
		}
		
		private function addTextFields():void 
		{
			_charTextField = new TextField();
			_charTextField.width = keyWidth;
			_charTextField.mouseEnabled = false;
			_charTextField.selectable = false;
			_charTextField.multiline = false;
			_charTextField.autoSize = TextFieldAutoSize.CENTER;
			_charTextField.defaultTextFormat = _textFormatChar;
			_charTextField.htmlText = _character;
			this.addChild(_charTextField);
			
			if(this._showShiftChar)
			{
				_charTextField.autoSize = TextFieldAutoSize.RIGHT;
				
				_shiftCharTextField = new TextField();
				_shiftCharTextField.width = keyWidth;
				_shiftCharTextField.mouseEnabled = false;
				_shiftCharTextField.selectable = false;
				_shiftCharTextField.multiline = false;
				_shiftCharTextField.autoSize = TextFieldAutoSize.LEFT;
				_shiftCharTextField.defaultTextFormat = _textFormatShiftChar;
				_shiftCharTextField.htmlText = _shiftCharacter;
				this.addChild(_shiftCharTextField);
				
				_shiftCharTextField.x = this.keyHeight/10;
				_shiftCharTextField.y = this.keyHeight/10;
				_charTextField.x = this.keyWidth - _charTextField.width - this.keyHeight/10;
				_charTextField.y = this._keyHeight - _charTextField.height - this.keyHeight/10;
			}
			else
			{
				_charTextField.x = (this.keyWidth - _charTextField.width) *0.5;
				_charTextField.y = (this._keyHeight - _charTextField.height) *0.5;
			}
		}
		
		private function popupChars():void
		{
			this._longPressed = true;
			this.dispatchEvent(new KeyEvent(KeyEvent.LONG_PRESS, this._type));
		}
		private function pressKey():void 
		{
			switch (this._type) 
			{
				case KeyName.KEYBOARD_KEY:
					this.dispatchEvent(new KeyEvent(KeyEvent.PRESSED, this._type));
				break;
				
				case KeyName.SPACEBAR_KEY:
					this.dispatchEvent(new KeyEvent(KeyEvent.PRESSED, this._type, " "));
				break;
				
				case KeyName.TAB_KEY:
					this.dispatchEvent(new KeyEvent(KeyEvent.PRESSED, this._type, "\t"));
				break;
				
				case KeyName.ENTER_KEY:
					this.dispatchEvent(new KeyEvent(KeyEvent.PRESSED, this._type, "\n"));
				break;
				
				case KeyName.BACKSPACE_KEY:
					this.dispatchEvent(new KeyEvent(KeyEvent.PRESSED, this._type));
				break;
				
				case KeyName.SHIFT_KEY:
					this.changeState();
					this.dispatchEvent(new KeyEvent(KeyEvent.PRESSED, this._type));
				break;
				
				case KeyName.CAPSLOCK_KEY:
					this.changeState();
					this.dispatchEvent(new KeyEvent(KeyEvent.PRESSED, this._type));
				break;
				
				default :
					this.dispatchEvent(new KeyEvent(KeyEvent.PRESSED, this._type, _character, _shiftCharacter));
			}
		}
		private function onDown(e:MouseEvent):void 
		{
			switch(this._type)
			{
				case KeyName.SHIFT_KEY:
				case KeyName.CAPSLOCK_KEY:
				break;
				
				case KeyName.BACKSPACE_KEY:
				case KeyName.ENTER_KEY:
				case KeyName.SPACEBAR_KEY:
				case KeyName.TAB_KEY:
					this.restartTimer();
				break;
				
				default:
					if(this._longPressKeys!=null)
						this.restartTimer();
			}
			
			this.reDraw(e.type);
		}
		private function onUp(e:MouseEvent):void 
		{
			switch(this._type)
			{
				case KeyName.SHIFT_KEY:
				case KeyName.CAPSLOCK_KEY:
					this.pressKey();
				break;
				
				case KeyName.BACKSPACE_KEY:
				case KeyName.ENTER_KEY:
				case KeyName.SPACEBAR_KEY:
				case KeyName.TAB_KEY:
					this.pressKey();
					this._longPressTimer.stop();
					this._longPressed = false;
				break;
				
				default:
					if(!this._longPressed)
						this.pressKey();
					if(this._longPressKeys!=null)
					{
						this._longPressTimer.stop();
						this._longPressed = false;
					}
			}
			
			this.reDraw(e.type);
		}
		private function onOver(e:MouseEvent):void 
		{
			this.reDraw(e.type);
		}
		private function onOut(e:MouseEvent):void 
		{
			this.reDraw(e.type);
		}
		private function onLongPress(e:TimerEvent):void
		{
			switch(this._type)
			{
				case KeyName.BACKSPACE_KEY:
				case KeyName.ENTER_KEY:
				case KeyName.SPACEBAR_KEY:
				case KeyName.TAB_KEY:
					this._longPressTimer = new Timer(1, 0);
					this._longPressTimer.addEventListener(TimerEvent.TIMER, whileLongPress);
					this._longPressTimer.start();
				break;
				
				default:
					this.popupChars();
			}
		}
		private function whileLongPress(e:TimerEvent):void
		{
			this.pressKey();
		}
		private function restartTimer():void
		{
			this._longPressTimer = new Timer(500, 1);
			this._longPressTimer.addEventListener(TimerEvent.TIMER, onLongPress);
			this._longPressTimer.start();
		}
		
		// needed for caps and shift
		private function changeState():void
		{
			if(this._enabled)
				this._enabled = false;
			else
				this._enabled = true;
		}
		
		private function reDraw(mouseStatus:String=""):void 
		{
			if(this._type==KeyName.SHIFT_KEY) 
			{
				if (this._enabled)
					this.setDownState();
				else
				{
					switch(mouseStatus)
					{
						case MouseEvent.MOUSE_OUT:
							this.setDefaultState();
						break;
						
						case MouseEvent.MOUSE_OVER:
						default:
							this.setOverState();
					}
				}
			}
			else if (this._type==KeyName.CAPSLOCK_KEY) 
			{
				if (this._enabled)
					this.setDownState();
				else
				{
					switch(mouseStatus)
					{
						case MouseEvent.MOUSE_OUT:
							this.setDefaultState();
						break;
						
						case MouseEvent.MOUSE_OVER:
						default:
							this.setOverState();
					}
				}
			}
			else 
			{
				switch(mouseStatus)
				{
					case MouseEvent.MOUSE_UP:
					case MouseEvent.MOUSE_OVER:
						this.setOverState();
					break;
					
					case MouseEvent.CLICK:
					case MouseEvent.MOUSE_DOWN:
						this.setDownState();
					break;
					
					case MouseEvent.MOUSE_OUT:
						this.setDefaultState();
					break;
				}
			}
		}
		
		private function setDefaultState():void 
		{
			_backGround.graphics.clear();
			_backGround.graphics.beginFill(this._keyColorDefault, 1);
			_backGround.graphics.lineStyle(0, _keyLineColor, 1, true);
			_backGround.graphics.drawRoundRect(0, 0, keyWidth, _keyHeight, _keyCorner, _keyCorner);
			_backGround.graphics.endFill();
		}
		private function setOverState():void 
		{			
			_backGround.graphics.clear();
			_backGround.graphics.beginFill(this._keyColorMouseOver, 1);
			_backGround.graphics.lineStyle(0, _keyLineColor, 1, true);
			_backGround.graphics.drawRoundRect(0, 0, keyWidth, _keyHeight, _keyCorner, _keyCorner);
			_backGround.graphics.endFill();
		}
		private function setDownState():void
		{
			_backGround.graphics.clear();
			_backGround.graphics.beginFill(this._keyColorMouseDown, 1);
			_backGround.graphics.lineStyle(0, _keyLineColor, 1, true);
			_backGround.graphics.drawRoundRect(0, 0, keyWidth, _keyHeight, _keyCorner, _keyCorner);
			_backGround.graphics.endFill();
		}
		
		/**
		 * Switch the normal character to shift character.
		 * 
		 */		
		public function shift():void
		{
			var key:Key;
			
			if(!this._showShiftChar && this._character!="" && this._shiftCharacter!="")
				this._charTextField.htmlText = this._shiftCharacter;
			else if(this._showShiftChar)
			{
				this._charTextField.htmlText = this._shiftCharacter;
				this._shiftCharTextField.htmlText = this._character;
			}
			
			if(this._longPressKeys!=null)
			{
				for(var i:uint=1; i<this._longPressKeys.numChildren; i++)
				{
					key = this._longPressKeys.getChildAt(i) as Key;
					key.shift();
				}
			}
		}
		/**
		 * Switch the normal character to shift character inside the special characters popup.
		 * 
		 */		
		public function shiftSpecialChars():void
		{
			var key:Key;
			
			if(this._specialCharsKeys!=null)
			{
				for(var j:uint=1; j<this._specialCharsKeys.numChildren; j++)
				{
					key = this._specialCharsKeys.getChildAt(j) as Key;
					key.shift();
				}
			}
		}
		/**
		 * Switch the shift character to normal character.
		 * 
		 */		
		public function unshift():void
		{
			var key:Key;
			
			if(!this._showShiftChar && this._character!="" && this._shiftCharacter!="")
				this._charTextField.htmlText = this._character;
			else if(this._showShiftChar)
			{
				this._charTextField.htmlText = this._character;
				this._shiftCharTextField.htmlText = this._shiftCharacter;
			}
			
			if(this._longPressKeys!=null)
			{
				for(var i:uint=1; i<_longPressKeys.numChildren; i++)
				{
					key = this._longPressKeys.getChildAt(i) as Key;
					key.unshift();
				}
			}
		}
		/**
		 * Switch the shift character to normal character inside the special characters popup.
		 * 
		 */		
		public function unshiftSpecialChars():void
		{
			var key:Key;
			
			if(this._specialCharsKeys!=null)
			{
				for(var j:uint=1; j<this._specialCharsKeys.numChildren; j++)
				{
					key = this._specialCharsKeys.getChildAt(j) as Key;
					key.unshift();
				}
			}
		}
		
		/**
		 * If this Key is a shift or caps key, switch it back to normal.
		 * 
		 */		
		public function disableShift():void
		{
			if(this._type==KeyName.SHIFT_KEY || this._type==KeyName.CAPSLOCK_KEY)
			{
				this._enabled = false;
				this.setDefaultState();
			}
		}
		
		public function get keyWidth():Number
		{
			return this._keyWidth;
		}
		public function get keyHeight():Number
		{
			return this._keyHeight;
		}
		public function get longPressKeys():Sprite
		{
			return this._longPressKeys;
		}
		public function set longPressKeys(value:Sprite):void
		{
			this._longPressKeys = value;
		}
		public function get specialCharsKeys():Sprite
		{
			return this._specialCharsKeys;
		}
		public function set specialCharsKeys(value:Sprite):void
		{
			this._specialCharsKeys = value;
		}
		public function get keyboardName():String
		{
			return this._keyboard;
		}
		public function set keyboardName(value:String):void
		{
			this._keyboard = value;
		}
		
		/**
		 * Add a symbol to the Key and hide the character textfields.
		*/
		public function setSymbol(symbol:DisplayObject):void
		{
			this._charTextField.visible = false;
			if(this._shiftCharTextField!=null) this._shiftCharTextField.visible = false;
			
			symbol.x = this.keyWidth *0.5;
			symbol.y = this.keyHeight *0.5;
			this.addChild(symbol);
		}
	}
}