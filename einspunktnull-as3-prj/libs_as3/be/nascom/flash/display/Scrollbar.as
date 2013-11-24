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

package be.nascom.flash.display
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle; 
	
	/**
	 * This Scrollbar is a wrapper class for the Displayobjects you're passing on to it.
	 * 
 	 * @author Rien Verbrugghe
	 * @mail rien.verbrugghe@nascom.be
	 * 
	 * */
	 
	public class Scrollbar extends MovieClip
	{
		private var _content:DisplayObject; 
		private var _contentMask:DisplayObject; 
		private var _scrollbar:MovieClip;
		private var _scrollbarContainer:MovieClip;
		private var _scrollbarDragger:MovieClip; 
		private var _scrollBarBackground:MovieClip;
		private var _scrollbarDraggerYoffset:Number;
		private var _scrollbarDraggerXoffset:Number;
		private var _scrollbarDraggerScaling:Boolean;
		private var _scrollBarButtonUp:MovieClip;
		private var _scrollBarButtonDown:MovieClip;
		private var _hitarea:MovieClip; 
		private var _blurred:Boolean; 
		private var _easing:Number; 
		private var _initY:Number; 
		private var _minY:Number;
		private var _maxY:Number;
		private var _percentuale:uint;
		private var _contentstarty:Number; 
		private var _bf:BlurFilter;
		private var _initialized:Boolean = false; 
		private var _moveAmount:Number;
		
		public function Scrollbar(content:DisplayObject, 
									contentMask:DisplayObject, 
									scrollbarDragger:MovieClip=null, 
									scrollBarBackground:MovieClip=null,
									scrollbarDraggerXoffset:Number=0,
									scrollbarDraggerYoffset:Number=0,
									scrollbarDraggerScaling:Boolean=false,
									scrollBarButtonUp:MovieClip=null, 
									scrollBarButtonDown:MovieClip=null,  
									easing:Number=4, 
									blurred:Boolean=false,
									moveAmount:Number=20)
		{
			super();
			
			if(scrollbarDragger==null)
			{
				scrollbarDragger = new MovieClip;
				scrollbarDragger.graphics.beginFill(0x000000);
				scrollbarDragger.graphics.drawRect(0,0,10,10);
				scrollbarDragger.graphics.endFill();
			}
			
			if(scrollBarBackground==null)
			{
				scrollBarBackground = new MovieClip;
				scrollBarBackground.graphics.beginFill(0xcccccc);
				scrollBarBackground.graphics.drawRect(0,0,10,contentMask.height);
				scrollBarBackground.graphics.endFill();
			}
			_moveAmount = moveAmount;			
			_content = content; 
			_contentMask = contentMask;
			_scrollBarBackground = scrollBarBackground;
			_scrollbarDragger = scrollbarDragger;
			_scrollbarDraggerXoffset = scrollbarDraggerXoffset;
			_scrollbarDraggerYoffset = scrollbarDraggerYoffset;
			_scrollbarDraggerScaling = scrollbarDraggerScaling;   
			_scrollBarButtonUp = scrollBarButtonUp;
			_scrollBarButtonDown = scrollBarButtonDown; 			
			_blurred = blurred; 
			_easing = easing;
			
			createHitArea();
			
			addChild(_hitarea);
			addChild(content);
			addChild(contentMask);
			
			_scrollbar = new MovieClip;
			_scrollbarContainer = new MovieClip;
			_scrollbar.x = _contentMask.width + scrollbarDraggerXoffset;
			_scrollbar.y = _scrollbarDraggerYoffset;
			_scrollbarContainer.addChild(_scrollBarBackground);
			_scrollbarContainer.addChild(_scrollbarDragger);
			if(_scrollBarButtonUp)_scrollbarContainer.y = _scrollBarButtonUp.height;
			if(_scrollBarButtonUp)_scrollbar.addChild(_scrollBarButtonUp);
			if(_scrollBarButtonDown)_scrollbar.addChild(_scrollBarButtonDown);
			_scrollbar.addChild(_scrollbarContainer);
			addChild(_scrollbar);
			
			_scrollBarBackground.height = _contentMask.height;
			if(_scrollBarButtonUp)_scrollBarBackground.height -= _scrollBarButtonUp.height;
			if(_scrollBarButtonDown)_scrollBarBackground.height -= _scrollBarButtonDown.height;
			_scrollBarBackground.addEventListener(MouseEvent.CLICK, gotoHandler);
			if(_scrollBarButtonUp)_scrollBarButtonUp.addEventListener(MouseEvent.CLICK, upHandler);
			if(_scrollBarButtonDown)_scrollBarButtonDown.addEventListener(MouseEvent.CLICK, downHandler);
			if(_scrollBarButtonDown)_scrollBarButtonDown.y = _scrollbarContainer.y+_scrollbarContainer.height;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		override public function get height():Number
		{
			return _contentMask.height;
		}
		
		private function gotoHandler(event:MouseEvent):void
		{
			_scrollbarDragger.y = event.localY;
		}
		
		public function scrollTo(percentage:Number):void
		{
			var limit:Number = this._scrollBarBackground.height - this._scrollbarDragger.height;
			var gotoY:Number = limit*percentage;
			if(gotoY>limit)gotoY = limit;
			_scrollbarDragger.y = gotoY;
			
//			_content.y = -(Math.abs(-_content.height+_contentMask.height)*percentage);						
//			trace("end: "+ Math.abs(-_content.height+_contentMask.height)*percentage );//						
//			trace("gotoper: "+percentage*100+"%");
//			trace("dragger: "+(_scrollbarDragger.y/limit)*100+"%");
		}
		
		private function upHandler(event:MouseEvent):void
		{
			_scrollbarDragger.y -= _moveAmount;
			if(_scrollbarDragger.y<0)_scrollbarDragger.y = 0;
		}	
		
		private function downHandler(event:MouseEvent):void
		{
			_scrollbarDragger.y += _moveAmount;
		}	
		
		public function init(event:Event=null):void 
		{
			if (checkPieces() == false) 
			{
				throw new Error("SCROLLBAR: CANNOT INITIALIZE"); 
			} else 
			{ 	
				if (_initialized == true)reset();
				
				_bf = new BlurFilter(0, 0, 1); 
				this._content.filters = new Array(_bf); 
				this._content.mask = this._contentMask; 
				this._content.cacheAsBitmap = true; 
				this._minY = _scrollBarBackground.y;
				this._scrollbarDragger.buttonMode = true; 
				this._contentstarty = _content.y; 
	
				_scrollbarDragger.addEventListener(MouseEvent.MOUSE_DOWN, clickHandle); 
				stage.addEventListener(MouseEvent.MOUSE_UP, releaseHandle); 
				stage.addEventListener(MouseEvent.MOUSE_WHEEL, wheelHandle, true); 
				this.addEventListener(Event.ENTER_FRAME, enterFrameHandle); 
				
				_initialized = true; 
			}
		}
		
		private function createHitArea():void
		{
			_hitarea = new MovieClip;
			_hitarea.graphics.beginFill(0x00ff00,0);
			_hitarea.graphics.drawRect(0,0,_contentMask.width,_contentMask.height);
			_hitarea.graphics.endFill();
		}	
		
		private function checkPieces():Boolean 
		{
			var ok:Boolean = true; 
			if (_content == null) {
				throw new Error("SCROLLBAR: DRAGGED not set"); 
				ok = false; 	
			}
			if (_contentMask == null) {
				throw new Error("SCROLLBAR: MASK not set"); 
				ok = false; 	
			}
			if (_scrollbarDragger == null) {
				throw new Error("SCROLLBAR: RULER not set"); 	
				ok = false; 
			}
			if (_scrollBarBackground == null) {
				throw new Error("SCROLLBAR: BACKGROUND not set"); 	
				ok = false; 
			}
			if (_hitarea == null) {
				throw new Error("SCROLLBAR: HITAREA not set"); 	
				ok = false; 
			}
			return ok; 
		}
				
		private function clickHandle(e:MouseEvent):void 
		{
			var rect:Rectangle = new Rectangle(_scrollBarBackground.x, _minY, 0, _maxY);
			_scrollbarDragger.startDrag(false, rect);
		}
		
		private function releaseHandle(e:MouseEvent):void
		{
			_scrollbarDragger.stopDrag();
		}
		
		private function wheelHandle(e:MouseEvent):void
		{
			if (this._hitarea.hitTestPoint(stage.mouseX, stage.mouseY, false))scrollData(e.delta);
		}
		
		private function enterFrameHandle(e:Event):void
		{
			positionContent();
		}
		
		private function scrollData(q:int):void
		{
			var d:Number;
			var rulerY:Number; 
			
			var quantity:Number = this._scrollbarDragger.height / 5; 

			d = -q * Math.abs(quantity); 
	
			if (d > 0) 
			{
				rulerY = Math.min(_maxY, _scrollbarDragger.y + d);
			}
			if (d < 0) 
			{
				rulerY = Math.max(_minY, _scrollbarDragger.y + d);
			}
			
			_scrollbarDragger.y = rulerY; 
	
			positionContent();
		}
		
		private function positionContent():void 
		{
			var upY:Number;
			var downY:Number;
			var curY:Number;
			
			if(_scrollbarDraggerScaling)this._scrollbarDragger.height = (this._contentMask.height / this._content.height) * this._scrollBarBackground.height;
			this._maxY = this._scrollBarBackground.height - this._scrollbarDragger.height;

			var limit:Number = this._scrollBarBackground.height - this._scrollbarDragger.height; 

 			if (this._scrollbarDragger.y > limit) 
 			{
				this._scrollbarDragger.y = limit; 
			} 
	
			checkContentLength();	
	
			_percentuale = (100 / _maxY) * _scrollbarDragger.y;
				
			upY = 0;
			downY = _content.height - (_contentMask.height / 2);
			 
			var fx:Number = _contentstarty - (((downY - (_contentMask.height/2)) / 100) * _percentuale); 
			var curry:Number = _content.y; 
			var finalx:Number = fx; 
			
			if (curry != finalx) 
			{
				var diff:Number = finalx-curry;
				curry += diff / _easing; 
				
				var bfactor:Number = Math.abs(diff)/8; 
				_bf.blurY = bfactor/2; 
				if (_blurred == true) 
				{
					_content.filters = new Array(_bf);
				}
			}
			
			_content.y = curry; 
		}
		
		private function checkContentLength():void
		{
			if (_content.height < _contentMask.height) {
				 _scrollBarBackground.visible = _scrollbarDragger.visible = false;
				 if(_scrollBarButtonUp)_scrollBarButtonUp.visible = false;
				 if(_scrollBarButtonDown)_scrollBarButtonDown.visible = false;
				
				reset();
			} else {
				_scrollBarBackground.visible = _scrollbarDragger.visible = true;
				 if(_scrollBarButtonUp)_scrollBarButtonUp.visible = true;
				 if(_scrollBarButtonDown)_scrollBarButtonDown.visible = true; 
			}
		}
		
		public function reset():void {
			_content.y = _contentstarty; 
			_scrollbarDragger.y = _scrollBarBackground.y;
		}
	}
}