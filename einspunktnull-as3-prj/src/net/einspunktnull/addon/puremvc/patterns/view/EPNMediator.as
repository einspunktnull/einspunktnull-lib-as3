package net.einspunktnull.addon.puremvc.patterns.view
{
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	/**
	 * @author Albrecht Nitsche
	 */
	public class EPNMediator extends Mediator implements IMediator
	{
		public static const NAME : String = "EPNMediator";

		protected var _notificationsList : Array = new Array();
		protected var _view : DisplayObject;

		public function EPNMediator(mediatorName : String, viewComponent : DisplayObject)
		{
			super(mediatorName, viewComponent);
			_view = viewComponent;
		}


		protected function addNotification(notification : String) : void
		{
			for each (var noti : String in _notificationsList)
			{
				if (noti == notification) return;
			}
			_notificationsList.push(notification);
		}

		override public function listNotificationInterests() : Array
		{
			return _notificationsList;
		}

		protected function setSize(rect : Rectangle) : void
		{
		}
	}
}
