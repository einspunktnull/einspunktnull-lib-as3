package net.einspunktnull.display.util
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.geom.Rectangle;

	/**
	 * @author Albrecht Nitsche
	 */
	public class DisplayObjectUtil
	{
		public static function removeAllChildren(displayObjectContainer : DisplayObjectContainer, recursive : Boolean = false) : void
		{
			while (displayObjectContainer.numChildren)
			{
				var child : DisplayObject = displayObjectContainer.getChildAt(0);

				if (child is DisplayObjectContainer && recursive)
				{
					removeAllChildren(DisplayObjectContainer(child), recursive);
				}
				else
				{
					displayObjectContainer.removeChild(child);
				}
			}
		}

		public static function getChildByName(name : String, displayObjectContainer : DisplayObjectContainer) : DisplayObject
		{
			for (var i : uint = 0;i < displayObjectContainer.numChildren;i++ )
			{
				var child : DisplayObject = displayObjectContainer[i];
				if (child.name == name) return child;
				else if (child is DisplayObjectContainer)
				{
					child = getChildByName(name, DisplayObjectContainer(child));
					if (child) return child;
				}
			}
			return null;
		}

		public static function center(obj : DisplayObject, container : Object) : void
		{
			var dim : Rectangle;
			if (container is Rectangle)
			{
				dim = (container as Rectangle);
			}
			else if (container is DisplayObjectContainer)
			{
				dim = getDimensionsRect((container as DisplayObjectContainer));
			}
			obj.x = dim.width / 2 - obj.width / 2 - obj.getBounds(obj).x;
			obj.y = dim.height / 2 - obj.height / 2 - obj.getBounds(obj).y;
		}

		public static function getDimensionsRect(container : DisplayObjectContainer) : Rectangle
		{
			var width : Number = (container is Stage) ? Stage(container).stageWidth : container.width;
			var height : Number = (container is Stage) ? Stage(container).stageHeight : container.height;
			return new Rectangle(container.x, container.y, width, height);
		}

		public static function fitInContainer(fitObj : DisplayObject, container : DisplayObjectContainer) : void
		{
			fitObj.scaleX = fitObj.scaleY = 1;
			var dim : Rectangle = getDimensionsRect(container);
			fitInDimensions(fitObj, dim.width, dim.height);
		}

		public static function fitInDimensions(fitObj : DisplayObject, width : Number, height : Number) : void
		{
			fitObj.scaleX = fitObj.scaleY = 1;
			var fitObjAspRat : Number = fitObj.width / fitObj.height;
			var targetAspRat : Number = width / height;
			var targetScale : Number = (fitObjAspRat >= targetAspRat) ? (width / fitObj.width) : (height / fitObj.height);
			fitObj.scaleX = fitObj.scaleY = targetScale;
		}

		public static function cropInDimensions(fitObj : DisplayObject, width : Number, height : Number, hAlign : String = "left", vAlign : String = "top") : void
		{
			fitObj.scaleX = fitObj.scaleY = 1;
			var fitObjAspRat : Number = fitObj.width / fitObj.height;
			var targetAspRat : Number = width / height;
			var targetScale : Number = (fitObjAspRat >= targetAspRat) ? (height / fitObj.height) : (width / fitObj.width);
			fitObj.scaleX = fitObj.scaleY = targetScale;
			if (vAlign == "bottom") fitObj.y = (fitObjAspRat >= targetAspRat) ? fitObj.height - height : height - fitObj.height;
			if (hAlign == "right") fitObj.x = (fitObjAspRat <= targetAspRat) ? fitObj.width - width : width - fitObj.width;
		}
	}
}
