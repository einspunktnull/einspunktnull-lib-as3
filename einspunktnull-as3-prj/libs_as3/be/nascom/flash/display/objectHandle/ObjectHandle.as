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
package be.nascom.flash.display.objectHandle{
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	//TODO: MOVE ALL MathUtil and RectangleUtil functions to a ObjectHandle Util

	public class ObjectHandle extends Sprite{
		
		public static const UPDATE:String="update";		
		public static const HANDLE_SELECTED:String="handle_selected";		
		public static var min_size:uint=20;//minimum size of the object handles
		
		public static const DRAG_NONE:String="drag_none";
		public static const DRAG_HANDLE:String="drag_handle";
		public static const DRAG_ROTATE:String="drag_rotate";
		public static const DRAG_OBJECT:String="drag_object";
		protected var _drag_mode:String="drag_none";

		protected var _drag_bounds:Rectangle;

		protected var _selected:Boolean=false;
		
		protected var _dragging:Boolean=false;
		
		protected var _object_rect:Rectangle;
		protected var _rotation:Number;		

		protected var _child:DisplayObject;
		public static var _drag_handle_graphic_size:uint=6;
		public static var _rotation_margin:uint=25;		

		protected var _handles:Array;//should be Vector...
		
		protected var _container:Sprite;
		protected var _drag_main_hotspot:HotSpot;
		protected var _rotate_hotspot:HotSpot;
		protected var _rotate_icon:RotateIcon;
		
		protected var _top_left_handle:Handle;
		protected var _top_middle_handle:Handle;
		protected var _top_right_handle:Handle;
		protected var _middle_left_handle:Handle;
		protected var _middle_right_handle:Handle;
		protected var _bottom_left_handle:Handle;
		protected var _bottom_middle_handle:Handle;
		protected var _bottom_right_handle:Handle;
		//protected var _center_graphic:DisplayObject; //a crosshair or so?!
		
		protected var _active_handle:Handle;//try to remove...
		
		protected var _rotation_graphic:Sprite;

		protected var _hanles_created:Boolean=false;
		protected var _pre_edit_properties:ObjectHandleProperties;
		
		public function ObjectHandle(child:DisplayObject,bounds:Rectangle,width:uint,height:uint,rotation:uint=0){
			super();
			_child=child;
			_container=new Sprite();
			addChild(_container);
			
			_rotate_hotspot=new HotSpot(0xFF0000,0);
			_container.addChild(_rotate_hotspot);
			_rotate_hotspot.visible=false;
			_rotate_hotspot.addEventListener(MouseEvent.MOUSE_OVER,showRotateIcon);
			_rotate_hotspot.addEventListener(MouseEvent.MOUSE_OUT,hideRotateIcon);
			_rotate_icon=new RotateIcon();

			_rotate_icon.visible=false;
			
			_container.addChild(_child);
			_drag_main_hotspot=new HotSpot(0xFFFFFF,0);
			_container.addChild(_drag_main_hotspot);
			_drag_bounds=bounds;
						
			_object_rect=new Rectangle(0,0,width,height);//just override width and height?!
			updateMainHotSpotAndChild();
			
			_rotation=_container.rotation=rotation;
			addChild(_rotate_icon);
			addEventListener(MouseEvent.MOUSE_DOWN,handleMouseDowns);
		}
		
		public function getObjectHandleProperties():ObjectHandleProperties{
			var props:ObjectHandleProperties=new ObjectHandleProperties();
			props.x=this.x;
			props.y=this.y;
			props.width=_object_rect.width;
			props.height=_object_rect.height;
			props.rotation=_rotation;
			return props;
		}

		public function select():void{
			if(_selected)return;
			if(!_hanles_created){
				createHandles();
				_hanles_created=true;
			}
			showHandles();
			_selected=true;
			this.parent.addEventListener(MouseEvent.MOUSE_MOVE,handleMouseMove);//not sure if these must be created everytime
			this.parent.addEventListener(MouseEvent.MOUSE_UP,stopAllDragging);
			_pre_edit_properties=getObjectHandleProperties();
			dispatchEvent(new Event(HANDLE_SELECTED,true));
		}
		public function deselect(e:Event=null):void{
			if(!_selected)return;
			_selected=false;
			hideHandles();
			this.parent.removeEventListener(MouseEvent.MOUSE_MOVE,handleMouseMove);//not sure if these must be removed everytim
			this.parent.removeEventListener(MouseEvent.MOUSE_UP,stopAllDragging);
			if(!_pre_edit_properties.equals(getObjectHandleProperties()))dispatchEvent(new Event(UPDATE,true));
		}
		
		//is this necessary?!
		protected function setDragLimits(rect:Rectangle):void{
			this._drag_bounds=rect;
		}		
		
		protected function handleMouseDowns(e:MouseEvent):void{
			select();
			if(e.target is Handle){
				_active_handle=Handle(e.target);//this may not even be important...
				handleHandleSelected();
			}else if(e.target==_rotate_hotspot){
				handleRotationHotspotDown()
			}else if(e.target==_drag_main_hotspot){
				startMainDrag();
			}
			e.stopImmediatePropagation();
		}
		
		protected function handleMouseMove(e:MouseEvent):void{
			if(_rotate_icon.visible){
				_rotate_icon.x=mouseX;
				_rotate_icon.y=mouseY;
				_rotate_icon.rotation=ObjectHandleMathUtil.radiansToDegrees(Math.atan2(mouseY,mouseX))+90;
			}
			if(!_dragging)return;
			if(!_drag_bounds.contains(parent.mouseX,parent.mouseY))stopAllDragging();
			switch(_drag_mode){
				case DRAG_HANDLE:
					handleDrag(parent.mouseX,parent.mouseY);
					_rotate_icon.visible=false;
					break;
				case DRAG_ROTATE:
					handleRotationDrag(parent.mouseX,parent.mouseY);
					break;
				case DRAG_OBJECT:
					this.handleMainDrag(parent.mouseX,parent.mouseY);
					break;
				case DRAG_NONE:
				default:
					break;
			}
		}
		protected function stopAllDragging(e:MouseEvent=null):void{
			//AS3SimpleTraceBox.trace("ObjectHandle.stopAllDragging()");
			reposition();
			_drag_mode=DRAG_NONE;
			_dragging=false;
			_active_handle=null;
			hideRotateIcon();
			dispatchEvent(new Event(UPDATE));//double check this... maybe with a dirty flag or so...
		}
		
		protected function getGlobalPositionOfHandle(handle:Handle):Point{
			var offset:Number=Math.atan2(handle.y,handle.x);
			var global_offset:Number=offset+ObjectHandleMathUtil.degreesToRadians(_rotation);
			var dist:Number=Math.sqrt(handle.x*handle.x+handle.y*handle.y);
			var global:Point=new Point();
			global.x=this.x+Math.cos(global_offset)*dist;
			global.y=this.y+Math.sin(global_offset)*dist;
			return global;		
		}
		
		protected function reposition():void{
			if(_drag_mode!=DRAG_HANDLE)return;
			var global:Point=getGlobalPositionOfHandle(getOpposingHandle(_locked_handle));
			this.x=_locked_handle_global.x+(global.x-_locked_handle_global.x)/2;
			this.y=_locked_handle_global.y+(global.y-_locked_handle_global.y)/2;
			updateToOrigin();
		}
		
		protected function getHandlesCenter():Point{
			return new Point(this._bottom_left_handle.x+(this._bottom_left_handle.x-this._top_left_handle.x)/2,
											this._bottom_left_handle.y+(this._bottom_left_handle.y-this._top_left_handle.y)/2);
		}
		
		protected function updateToOrigin():void{
			for each(var h:Handle in _handles){
				h.x=_object_rect.width*h.grid_point.x;
				h.y=_object_rect.height*h.grid_point.y;
			}
			updateMainHotSpotAndChild();
		}
		
		protected function update():void{
			
			for each(var handle:Handle in _handles){
				if(handle==_locked_handle)continue;
				handle.x=_locked_handle.x+_object_rect.width*(handle.grid_point.x-_locked_handle.grid_point.x);
				handle.y=_locked_handle.y+_object_rect.height*(handle.grid_point.y-_locked_handle.grid_point.y);
			}
			
			var temp_center:Point=getHandlesCenter();
											
			
			_drag_main_hotspot.width=_child.width=_object_rect.width;
			_drag_main_hotspot.height=_child.height=_object_rect.height;
			_drag_main_hotspot.x=_child.x=this._top_left_handle.x;
			_drag_main_hotspot.y=_child.y=this._top_left_handle.y;
			_rotate_hotspot.x=_child.x-_rotation_margin;
			_rotate_hotspot.y=_child.y-_rotation_margin;
			_rotate_hotspot.width=_object_rect.width+_rotation_margin*2;
			_rotate_hotspot.height=_object_rect.height+_rotation_margin*2;
			
		}
		
		protected function updateRotation():void{
			_container.rotation=ObjectHandleMathUtil.constrainDegreeTo360(_rotation);						
		}
		protected function updatePosition():void{
		}
		
		//try to remove this...
		protected function updateMainHotSpotAndChild():void{
			_drag_main_hotspot.width=_child.width=_object_rect.width;
			_drag_main_hotspot.height=_child.height=_object_rect.height;
			_drag_main_hotspot.x=_child.x=_object_rect.width/-2;
			_drag_main_hotspot.y=_child.y=_object_rect.height/-2;
			_rotate_hotspot.x=_child.x-_rotation_margin;
			_rotate_hotspot.y=_child.y-_rotation_margin;
			_rotate_hotspot.width=_object_rect.width+_rotation_margin*2;
			_rotate_hotspot.height=_object_rect.height+_rotation_margin*2;
		}

		
		//could (should?) be static variables...
		protected var _drag_distance:Number;
		protected var _drag_point:Point=new Point();

		protected var _rotation_offset:Number;
		protected var _drag_offset:Point=new Point();

		protected var _locked_handle:Handle;
		protected var _locked_handle_global:Point=new Point();
		
		protected var _drag_handle_anchor:Point=new Point();
		
		protected function getOpposingHandle(handle:Handle):Handle{
			var opposite:Handle;
			switch(handle){
				case _top_left_handle:
					opposite=_bottom_right_handle;
					break;
				case _top_middle_handle:
					opposite=_bottom_middle_handle;
					break;
				case _top_right_handle:
					opposite=_bottom_left_handle;
					break;
				case _middle_left_handle:
					opposite=_middle_right_handle;
					break;
				case _middle_right_handle:
					opposite=_middle_left_handle;
					break;
				case _bottom_right_handle:
					opposite=_top_left_handle;
					break;
				case _bottom_middle_handle:
					opposite=_top_middle_handle;
					break;
				case _bottom_left_handle:
					opposite=_top_right_handle;
					break;
			}
			return opposite;
		}
		
		
		//===========:HANDLE DRAGS:===============		
		protected function handleHandleSelected():void{
			//AS3SimpleTraceBox.trace("ObjectHandle.handleHandleSelected()");
			_drag_mode=DRAG_HANDLE;
			_locked_handle=getOpposingHandle(_active_handle);
			_locked_handle_global=getGlobalPositionOfHandle(_locked_handle);
			_dragging=true;
		}
		
		protected function handleDrag(x:Number,y:Number):void{

			_drag_point.x=x;
			_drag_point.y=y;
			
			_drag_distance=Point.distance(_drag_point,_locked_handle_global);
			if(_drag_distance<min_size)return;

			var angle:Number=Math.atan2(y-_locked_handle_global.y,x-_locked_handle_global.x);

			angle-=ObjectHandleMathUtil.degreesToRadians(_rotation);
			if(_active_handle.modify_width){
				_object_rect.width=Math.abs(Math.cos(angle))*_drag_distance;
			}
			if(_active_handle.modify_height){
				_object_rect.height=Math.abs(Math.sin(angle))*_drag_distance;	
			}

			update();
		}
		
		
		//===========:ROTATION DRAG:===============		
		protected function handleRotationHotspotDown():void{
			//AS3SimpleTraceBox.trace("ObjectHandle.handleRotationHotspotDown()");
			_drag_mode=DRAG_ROTATE;
			_rotation_offset=Math.atan2(_container.mouseY,_container.mouseX);
			_dragging=true;
		}
		protected function handleRotationDrag(x:Number,y:Number):void{
			var angle:Number=Math.atan2(y-this.y,x-this.x);
			_rotation=ObjectHandleMathUtil.radiansToDegrees(angle-_rotation_offset);
			updateRotation();
		}
		protected function showRotateIcon(e:MouseEvent):void{
			_rotate_icon.visible=true;
		}
		protected function hideRotateIcon(e:MouseEvent=null):void{
			if(_dragging)return;
			_rotate_icon.visible=false;
		}
		
		//===========:MAIN DRAG:===============
		protected function startMainDrag():void{
			_drag_offset=new Point(this.parent.mouseX-this.x,this.parent.mouseY-this.y);
			//AS3SimpleTraceBox.trace("ObjectHandle.handleStartMainDrag() offset:"+_drag_offset);
			if(!_selected)select();
			_drag_mode=DRAG_OBJECT
			_dragging=true;
		}
		protected function handleMainDrag(x:Number,y:Number):void{
			this.x=x-_drag_offset.x;
			this.y=y-_drag_offset.y;
			updatePosition();
		}
		protected function stopMainDrag(e:Event):void{
			//AS3SimpleTraceBox.trace("ObjectHandle.handleStopMainDrag()");
			stopAllDragging();
		}
		
		
		
		//===================:HANLDES INSTANTIATION:=======================
		protected function getHandleGraphic(x:int,y:int):Sprite{
			var handle:Sprite=new Sprite();
			handle.graphics.lineStyle(1,0x000000);
			handle.graphics.beginFill(0xFFFFFF);
			handle.graphics.drawRect(0,0,_drag_handle_graphic_size,_drag_handle_graphic_size);
			handle.x=x;
			handle.y=y;
			return handle;
		}

		/**
		 * These could be in a singleton or a static instance, as only one can be selected at a time... 
		 */
		protected function createHandles():void{
			//AS3SimpleTraceBox.trace("ObjectHandle.createHandles()");
			//TOP LEFT
			var handle:Sprite=getHandleGraphic(-_drag_handle_graphic_size,-_drag_handle_graphic_size);
			_top_left_handle=new Handle(Handle.TOP_LEFT ,true,true, handle);
			_container.addChild(_top_left_handle);

			//TOP MIDDLE
			handle=getHandleGraphic(Math.round(-_drag_handle_graphic_size*.5),-_drag_handle_graphic_size);
			_top_middle_handle=new Handle(Handle.TOP_MIDDLE,false,true,handle);
			_container.addChild(_top_middle_handle);
			
			//TOP RIGHT
			handle=getHandleGraphic(0,-_drag_handle_graphic_size);
			_top_right_handle=new Handle(Handle.TOP_RIGHT,true,true ,handle);
			_container.addChild(_top_right_handle);
			
			//MIDDLE LEFT
			handle=getHandleGraphic(-_drag_handle_graphic_size,Math.round(-_drag_handle_graphic_size*.5));
			_middle_left_handle=new Handle(Handle.MIDDLE_LEFT,true,false,handle);
			_container.addChild(_middle_left_handle);
			
			//MIDDLE RIGHT
			handle=getHandleGraphic(0,Math.round(-_drag_handle_graphic_size*.5));			
			_middle_right_handle=new Handle(Handle.MIDDLE_RIGHT,true,false,handle);
			_container.addChild(_middle_right_handle);
			
			//BOTTOM LEFT
			handle=getHandleGraphic(-_drag_handle_graphic_size,0);			
			_bottom_left_handle=new Handle(Handle.BOTTOM_LEFT, true,true,handle);
			_container.addChild(_bottom_left_handle);
			
			//BOTTOM MIDDLE
			handle=getHandleGraphic(Math.round(-_drag_handle_graphic_size*.5),0);			
			_bottom_middle_handle=new Handle(Handle.BOTTOM_MIDDLE, false,true,handle);
			_container.addChild(_bottom_middle_handle);
			
			//BOTTOM RIGHT
			handle=getHandleGraphic(0,0);
			_bottom_right_handle=new Handle(Handle.BOTTOM_RIGHT, true,true,handle);
			_container.addChild(_bottom_right_handle);
			
			_handles=new Array(_top_left_handle,_top_middle_handle,_top_right_handle,_middle_left_handle,_middle_right_handle,_bottom_left_handle,_bottom_middle_handle,_bottom_right_handle);

			updateToOrigin();

		}

		protected function showHandles():void{
			for each(var handle:Handle in _handles){
				handle.visible=true;
			}
			_rotate_hotspot.visible=true;
		}
		protected function hideHandles():void{
			for each(var handle:Handle in _handles){
				handle.visible=false;
			}		
			_rotate_hotspot.visible=false;
		}
		
		
	}
}