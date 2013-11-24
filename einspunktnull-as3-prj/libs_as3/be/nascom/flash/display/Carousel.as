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
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.utils.Dictionary;

	/** 
	 * 
	 * Typically used for product or image showcases, Carousel places instances DisplayObject in a circle with depth transformation, which rotates according to the mouse movements, mimicking the movement of a carousel amusement ride. When an item is clicked, it is centered automatically and the automatic rotation stops until autoRotate() is called.
	 * Carousel uses the Caurina Tweener engine to do the automatic rotation.
	 * 
	 * @see http://code.google.com/p/tweener/
	 * 
	 * @example The following code creates a Carousel for which the rotational ellipse has a horizontal radius of 300px and a vertical radius of 35px (ie. 600px wide and 70px high), assuming movieClip1-6 are assumed to be instanciated but not placed on the stage. When an item is clicked, it will be centered and the automatic rotation is halted.
	 * 	<listing version="3.0">
	 * 		import be.nascom.flash.ui.Carousel;
	 * 		
	 * 		var carousel : Carousel = new Carousel(300, 35);
	 * 		carousel.depthOfField = 10;
	 * 		carousel.x = stage.stageWidth/2;
	 * 		carousel.y = stage.stageHeight/2;
	 * 		addChild(carousel);
	 * 
	 * 		carousel.addChild(movieClip1);
	 * 		carousel.addChild(movieClip2);
	 * 		carousel.addChild(movieClip3);
	 * 		carousel.addChild(movieClip4);
	 * 		carousel.addChild(movieClip5);
	 * 		carousel.addChild(movieClip6);
	 * </listing>
	 * 
	 * @author David Lenaerts
	 * @mail david.lenaerts@nascom.be
	 * 
 	 */
 	 
	public class Carousel extends MovieClip
	{
		private var _items : Array = new Array();
		
		private var _depthOfField : Number = 0;
		
		private var _rotation : Number = 0;
		private var _zValues : Dictionary = new Dictionary();
		
		private var _horizontalRadius : Number, _verticalRadius : Number;
		private var _rotPerItem : Number;
		
		private var _orders : Dictionary = new Dictionary();
		
		private var _blurFilters : Dictionary = new Dictionary();
		
		private var _perspectiveCorrect : Boolean = true;
		
		private var _currentRotationSpeed : Number = 0;
		
		private var _rotationSpeed : Number = 0.05;
		
		private var _hitField : Sprite;
		
		/**
		 * Instantiates a Carousel object.
		 * @param horizontalRadius The horizontal radius of the ellipse on which the items will be arranged.
		 * @param verticalRadius The horizontal radius of the ellipse on which the items will be arranged.
		 * @param hitField The hitfield area in which the interaction occurs. If provided, the carousel will only rotate when the mouse is over the hitfield.
		 * @param perspectiveCorrect Defines the positioning of the items. A value of true will place them in a more realistic fashion, but the spacing will look less even.
		 */
		public function Carousel(horizontalRadius : Number, verticalRadius : Number, hitField : Sprite = null, perspectiveCorrect : Boolean = false)
		{
			_hitField = hitField;
			_horizontalRadius = horizontalRadius;
			_verticalRadius = verticalRadius;
			_perspectiveCorrect = perspectiveCorrect;
			this.buttonMode = true;
			super();
		}
		
		/**
		 * Adds a DisplayObject to the caroussel.
		 * @param child The DisplayObject to be added. It can not be on the stage already.
		 */
		override public function addChild(child:DisplayObject):DisplayObject
		{
			var superReturn : DisplayObject = super.addChild(child);
			_blurFilters[child] = new BlurFilter(0, 0);
			_orders[child] = _items.length;
			_items.push(child);
			_rotPerItem = 2*Math.PI/_items.length;
			updateItemPositions();
			child.addEventListener(MouseEvent.CLICK, handleItemClick);
			return superReturn;
		}
		
		/**
		 * The current amount of rotation
		 */
		public function get angle() : Number
		{
			return _rotation;
		}
		
		public function set angle(value : Number) : void
		{
			_rotation = value;
			updateItemPositions();
		}
		
		/**
		 * The horizontal radius of the ellipse on which the items will be arranged.
		 */
		public function get horizontalRadius() : Number
		{
			return _horizontalRadius;
		}
		
		public function set horizontalRadius(value : Number) : void
		{
			_horizontalRadius = value;
		}
		
		/**
		 * The vertical radius of the ellipse on which the items will be arranged.
		 */
		public function get verticalRadius() : Number
		{
			return _verticalRadius;
		}
		
		public function set verticalRadius(value : Number) : void
		{
			_verticalRadius = value;
		}
		
		/**
		 * Blurs items that are farther away. Higher values create a stronger blur.
		 */
		public function get depthOfField() : Number
		{
			return _depthOfField;
		}
		
		public function set depthOfField(value : Number) : void
		{
			if (value == 0) {
				for (var i : int = 0; i < _items.length; i++)
					removeBlur(_items[i]);
			}
			_depthOfField = value;
		}
		
		/**
		 * Defines the positioning of the items. A value of true will place them in a more realistic fashion, but the spacing will look less even.
		 */
		public function get perspectiveCorrect() : Boolean
		{
			return _perspectiveCorrect;
		}
		
		public function set perspectiveCorrect(value : Boolean) : void
		{
			_perspectiveCorrect = value;
			updateItemPositions();
		}
		
		/**
		 * The maximum speed by which the items will rotate automatically. The speed is the difference in the rotation angle per frame.
		 */
		public function get rotationSpeed() : Number
		{
			return _rotationSpeed;
		}
		
		public function set rotationSpeed(value : Number) : void
		{
			_rotationSpeed = value;
		}
		
		/**
		 * @private
		 * The current rotational speed by which the items are rotating automatically. These should not be altered, and are made public for access by Tweener
		 */
		public function get currentRotationSpeed() : Number
		{
			return _currentRotationSpeed;
		}
		
		public function set currentRotationSpeed(value : Number) : void
		{
			_currentRotationSpeed = value;
		}
		
		/**
		 * Rotates the items automatically according to mouse position.
		 */
		public function autoRotate() : void
		{
			_currentRotationSpeed = 0;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}
		
		/**
		 * Stops the automatic rotation based on the mouse position
		 */
		public function stopAutoRotate() : void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}
		
		/**
		 * Stops the automatic rotation based oon the mouse position, and rotates the carousel so that the child DisplayObject is centered in the front of the viewer.
		 * @param child The child DisplayObject to be shown in the center.
		 */
		public function centerToChild(child : DisplayObject) : void
		{
			var i : int = _items.length;
			var current : DisplayObject;
			var newAngle : Number = Math.PI*2-_orders[child]*_rotPerItem;
			var currentAngle : Number = _rotation;
			
			/* reset angle within bounds [0, Math.PI*2] for comparison with new angle */
			while (currentAngle > Math.PI*2) {
				currentAngle -= Math.PI*2;
			}
			while (currentAngle < 0) {
				currentAngle += Math.PI*2;
			}
			
			_rotation = currentAngle;
			
			/* find shortest route to new position */
			if (Math.abs(newAngle - _rotation) > Math.PI) {
				if (newAngle < _rotation)
					newAngle += 2*Math.PI;
				else
					newAngle -= 2*Math.PI;
			}
			
			stopAutoRotate();
			
			/* tween to new position */
//			Tweener.addTween(this, {angle : newAngle, transition:"easeOutQuad", time:1});
			TweenLite.to(this, 1, {angle:newAngle, ease:Quad.easeOut});
		}
		
		private function updateItemPositions() : void
		{
			var i : int = _items.length;
			var current : DisplayObject;
			var itemRotation : Number;
			var x : Number, z : Number;
			
			while (current = _items[--i] as DisplayObject) {
				itemRotation = _rotation+_rotPerItem*_orders[current];
				z = 2-Math.cos(itemRotation);
				x = Math.sin(itemRotation);
				
				if (_perspectiveCorrect) {
					current.x = 2*x/z*_horizontalRadius-current.getBounds(current).x;
					current.y = (z-2)/z*_verticalRadius-current.getBounds(current).y;
				}
				else {
					current.x = x*_horizontalRadius-current.getBounds(current).x;
					current.y = (z-3)*_verticalRadius;
				}
				
				_zValues[current] = z;
				
				current.scaleX = 1/z;
				current.scaleY = 1/z;
				
				updateBlur(current, z); 
			} 
			sortChildren();
		}
		
		/**
		 * Updates the blur per item caused by the depth of field property.
		 */
		private function updateBlur(target : DisplayObject, zIndex : Number) : void
		{
			if (_depthOfField != 0) {
				var strength : Number = (zIndex-1)*_depthOfField*.5;
				var blurFilter : BlurFilter = _blurFilters[target] as BlurFilter;
				blurFilter.blurX = strength;
				blurFilter.blurY = strength;
				target.filters = [ blurFilter ];
			}
			else target.filters = null;
		}
		
		/**
		 * Removes the blur from a target displayobject
		 */
		private function removeBlur(target : DisplayObject) : Array
		{
			var filters : Array = target.filters;
			var blurFilter : BlurFilter = _blurFilters[target] as BlurFilter;
			for (var i : int = 0; i < filters.length; i++) {
				if (filters[i] == blurFilter) 
					filters.splice(i, 1);
			}
			return filters;
		}
		
		/**
		 * Sorts the items according to their depth position, using a bubble algorithm.
		 */
		private function sortChildren() : void
		{
			var next : DisplayObject;
			var current : DisplayObject;
			var i : int;
			var len : int =  _items.length;
			
			// a bubble sort algorithm
			for (var j : int = 0; j < len-2; j++) {
				i = len;
				while (current = _items[--i] as DisplayObject) {
					next = _items[i-1];
					
					if (next && _zValues[current] > _zValues[next] && getChildIndex(current) > getChildIndex(next)) {
						_items.splice(i-1, 1);
						_items.splice(i, 0, next);
						swapChildren(current, next);
					}
				}
			}
		}
		
		/**
		 * updates the current rotation speed according to mouse position
		 */
		private function handleMouseMove(event : MouseEvent) : void
		{
			var newSpeed : Number;
			
			// need mouseMovement on the bounding box, not the actual shape
			if ((_hitField && _hitField.hitTestPoint(stage.mouseX, stage.mouseY))
				|| (!_hitField && hitTestPoint(stage.mouseX, stage.mouseY)))
				newSpeed = -mouseX/_horizontalRadius*_rotationSpeed;
			else 
				newSpeed = 0;
		
//			Tweener.addTween(this, {currentRotationSpeed : newSpeed, time : 0.35, transition:"linear"} );
			TweenLite.to(this, .35, {currentRotationSpeed:newSpeed});
		}
		
		/**
		 * Updates the angle according to the current rotation speed
		 */
		private function handleEnterFrame(event : Event) : void
		{
			angle += _currentRotationSpeed;
		}
		
		/**
		 * Centers the clicked child
		 */
		private function handleItemClick(event : MouseEvent) : void
		{
			centerToChild(event.target as DisplayObject);
		}
	}
}