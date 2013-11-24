package net.einspunktnull.addon.puremvc.patterns.view.vc
{
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;

	import net.einspunktnull.display.base.BaseSprite;


	/**
	 * @author Albrecht Nitsche
	 */
	public class EPNCanvasVC extends BaseSprite
	{
		private var _dictionary : Dictionary = new Dictionary();

		public function EPNCanvasVC()
		{
			super();
		}

		public function addItem(asset : DisplayObject, name : String) : void
		{
			if (asset && name)
			{
				_dictionary[name] = asset;
				addChild(asset);
			}
		}

		public function removeItem(name : String) : void
		{
			for (var i : int = 0; i < numChildren; i++)
			{
				if (getChildAt(i) == _dictionary[name])
				{
					removeChildAt(i);
					_dictionary[name] = null;
				}
			}

		}

		public function getItem(name : String) : DisplayObject
		{
			return _dictionary[name];
		}

		override public function onResize(event : Event) : void
		{
			super.onResize(event);
			dispatchEvent(event);
		}

	}
}
