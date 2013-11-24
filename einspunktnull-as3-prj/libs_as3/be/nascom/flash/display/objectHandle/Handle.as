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
package be.nascom.flash.display.objectHandle
{	
	import flash.display.Sprite;
	import flash.geom.Point;

	public class Handle extends Sprite{
		
		public static const TOP_LEFT:Point=new Point(-.5,-.5);
		public static const TOP_MIDDLE:Point=new Point(0,-.5);
		public static const TOP_RIGHT:Point=new Point(.5,-.5);
		
		public static const MIDDLE_LEFT:Point=new Point(-.5,0);
		public static const MIDDLE_MIDDLE:Point=new Point(0,0);
		public static const MIDDLE_RIGHT:Point=new Point(.5,0);
		
		public static const BOTTOM_LEFT:Point=new Point(-.5,.5);
		public static const BOTTOM_MIDDLE:Point=new Point(0,.5);
		public static const BOTTOM_RIGHT:Point=new Point(.5,.5);
		
		protected var _handle:Sprite;
		protected var _grid_point:Point;
		public function get grid_point():Point{
			return _grid_point;
		}
		protected var _move_relative_to:Handle;
		protected var _modify_width:Boolean;
		public function get modify_width():Boolean{
			return _modify_width;
		}
		
		protected var _modify_height:Boolean;
		public function get modify_height():Boolean{
			return _modify_height;
		}
		
		public function Handle(grid_point:Point,modify_width:Boolean,modify_height:Boolean,handle:Sprite){
			super();
			this.buttonMode=true;
			this.useHandCursor=true;
			this.mouseChildren=false;
			_grid_point=grid_point;
			_modify_width=modify_width;
			_modify_height=modify_height;
			_handle=handle;
			//_handle.addEventListener(MouseEvent.MOUSE_OVER,handleHandleMouseOver);
			//_handle.addEventListener(MouseEvent.MOUSE_OUT,handleHandleMouseOut);
			addChild(_handle);
		}

		
		/*
		protected function handleHandleMouseOver(e:MouseEvent):void{
			//in case of a rollover effect
			e.stopImmediatePropagation();
		}
		protected function handleHandleMouseOut(e:MouseEvent):void{
			//in case of a rollover effect
			e.stopImmediatePropagation();
		}*/
		
	}
}