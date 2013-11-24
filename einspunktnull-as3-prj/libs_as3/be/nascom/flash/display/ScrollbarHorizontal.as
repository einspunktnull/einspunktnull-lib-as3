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
	 * This ScrollbarHorizontal is a wrapper class for the Displayobjects you're passing on to it.
	 * 
 	 * @author Rien Verbrugghe
	 * @mail rien.verbrugghe@nascom.be
	 * 
	 * */
	 
	public class ScrollbarHorizontal extends MovieClip
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
		private var _scrollBarButtonLeft:MovieClip;
		private var _scrollBarButtonRight:MovieClip;
		private var _hitarea:MovieClip; 
		private var _blurred:Boolean; 
		private var _easing:Number; 
		private var _initX:Number; 
		private var _minX:Number;
		private var _maxX:Number;
		private var _percentuale:uint;
		private var _contentstartx:Number; 
		private var _bf:BlurFilter;
		private var _initialized:Boolean = false; 
		private var _moveAmount:Number;
		
		public function ScrollbarHorizontal(content:DisplayObject, 
									contentMask:DisplayObject, 
									scrollbarDragger:MovieClip=null, 
									scrollBarBackground:MovieClip=null,
									scrollbarDraggerXoffset:Number=0,
									scrollbarDraggerYoffset:Number=0,
									scrollbarDraggerScaling:Boolean=false,
									scrollBarButtonLeft:MovieClip=null, 
									scrollBarButtonRight:MovieClip=null,  
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
				scrollBarBackground.graphics.drawRect(0,0,contentMask.width,10);
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
			_scrollBarButtonLeft = scrollBarButtonLeft;
			_scrollBarButtonRight = scrollBarButtonRight; 			
			_blurred = blurred; 
			_easing = easing;
			
			createHitArea();
			
			addChild(_hitarea);
			addChild(content);
			addChild(contentMask);
			
			_scrollbar = new MovieClip;
			_scrollbarContainer = new MovieClip;
			_scrollbar.x = _scrollbarDraggerXoffset;
			_scrollbar.y = _contentMask.height + scrollbarDraggerYoffset;
			_scrollbarContainer.addChild(_scrollBarBackground);
			_scrollbarContainer.addChild(_scrollbarDragger);
			if(_scrollBarButtonLeft)_scrollbarContainer.x = _scrollBarButtonLeft.width;
			if(_scrollBarButtonLeft)_scrollbar.addChild(_scrollBarButtonLeft);
			if(_scrollBarButtonRight)_scrollbar.addChild(_scrollBarButtonRight);
			_scrollbar.addChild(_scrollbarContainer);
			addChild(_scrollbar);
			
			_scrollBarBackground.width = _contentMask.width;
			if(_scrollBarButtonLeft)_scrollBarBackground.width -= _scrollBarButtonLeft.width;
			if(_scrollBarButtonRight)_scrollBarBackground.width -= _scrollBarButtonRight.width;
			_scrollBarBackground.addEventListener(MouseEvent.CLICK, gotoHandler);
			if(_scrollBarButtonLeft)_scrollBarButtonLeft.addEventListener(MouseEvent.CLICK, prevHandler);
			if(_scrollBarButtonRight)_scrollBarButtonRight.addEventListener(MouseEvent.CLICK, nextHandler);
			if(_scrollBarButtonRight)_scrollBarButtonRight.x = _scrollbarContainer.x+_scrollbarContainer.width;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		override public function get width():Number
		{
			return _contentMask.width;
		}
		
		private function gotoHandler(event:MouseEvent):void
		{
			_scrollbarDragger.x = event.localX;
		}
		
		public function scrollTo(percentage:Number):void
		{
			var limit:Number = this._scrollBarBackground.width - this._scrollbarDragger.width;
			var gotoX:Number = limit*percentage;
			if(gotoX>limit)gotoX = limit;
			_scrollbarDragger.x = gotoX;
			
//			_content.y = -(Math.abs(-_content.height+_contentMask.height)*percentage);						
//			trace("end: "+ Math.abs(-_content.height+_contentMask.height)*percentage );//						
//			trace("gotoper: "+percentage*100+"%");
//			trace("dragger: "+(_scrollbarDragger.y/limit)*100+"%");
		}
		
		public function prevHandler(event:MouseEvent=null):void
		{
			_scrollbarDragger.x -= _moveAmount;
			if(_scrollbarDragger.x<0)_scrollbarDragger.x = 0;
		}	
		
		public function nextHandler(event:MouseEvent=null):void
		{
			_scrollbarDragger.x += _moveAmount;
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
				this._minX = _scrollBarBackground.x;
				this._scrollbarDragger.buttonMode = true; 
				this._contentstartx = _content.x; 
	
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
			var rect:Rectangle = new Rectangle(_minX, 0, _maxX, 0);
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
			var rulerX:Number; 
			
			var quantity:Number = this._scrollbarDragger.width / 5; 

			d = -q * Math.abs(quantity); 
	
			if (d > 0) 
			{
				rulerX = Math.min(_maxX, _scrollbarDragger.x + d);
			}
			if (d < 0) 
			{
				rulerX = Math.max(_minX, _scrollbarDragger.x + d);
			}
			
			_scrollbarDragger.x = rulerX; 
	
			positionContent();
		}
		
		private function positionContent():void 
		{
			var upX:Number;
			var downX:Number;
			var curX:Number;
			
			if(_scrollbarDraggerScaling)this._scrollbarDragger.width = (this._contentMask.width / this._content.width) * this._scrollBarBackground.width;
			this._maxX = this._scrollBarBackground.width - this._scrollbarDragger.width;

			var limit:Number = this._scrollBarBackground.width - this._scrollbarDragger.width; 

 			if (this._scrollbarDragger.x > limit) 
 			{
				this._scrollbarDragger.x = limit; 
			} 
	
			checkContentLength();	
	
			_percentuale = (100 / _maxX) * _scrollbarDragger.x;
				
			upX = 0;
			downX = _content.width - (_contentMask.width / 2);
			 
			var fx:Number = _contentstartx - (((downX - (_contentMask.width/2)) / 100) * _percentuale); 
			var currx:Number = _content.x; 
			var finalx:Number = fx; 
			
			if (currx != finalx) 
			{
				var diff:Number = finalx-currx;
				currx += diff / _easing; 
				
				var bfactor:Number = Math.abs(diff)/8; 
				_bf.blurX = bfactor/2; 
				if (_blurred == true) 
				{
					_content.filters = new Array(_bf);
				}
			}
			
			_content.x = currx; 
		}
		
		private function checkContentLength():void
		{
			if (_content.width < _contentMask.width) {
				 _scrollBarBackground.visible = _scrollbarDragger.visible = false;
				 if(_scrollBarButtonLeft)_scrollBarButtonLeft.visible = false;
				 if(_scrollBarButtonRight)_scrollBarButtonRight.visible = false;
				
				reset();
			} else {
				_scrollBarBackground.visible = _scrollbarDragger.visible = true;
				 if(_scrollBarButtonLeft)_scrollBarButtonLeft.visible = true;
				 if(_scrollBarButtonRight)_scrollBarButtonRight.visible = true; 
			}
		}
		
		public function reset():void {
			_content.x = _contentstartx; 
			_scrollbarDragger.x = _scrollBarBackground.x;
		}
	}
}