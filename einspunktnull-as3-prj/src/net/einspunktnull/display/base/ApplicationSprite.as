package net.einspunktnull.display.base
{

	import avmplus.getQualifiedClassName;

	import net.einspunktnull.base.error.UncaughtErrorManager;

	import org.libspark.ui.SWFWheel;

	import flash.events.Event;



	/**
	 * @author Albrecht Nitsche
	 */
	public class ApplicationSprite extends BaseSprite
	{
		protected var _appName : String;

		public function ApplicationSprite(appName : String = null)
		{
			super();
			_appName = appName ? appName : getQualifiedClassName(this);
			UncaughtErrorManager.add(loaderInfo);
		}

		override protected function onStage(event : Event) : void
		{
			super.onStage(event);
			SWFWheel.initialize(stage);
		}

		override protected function onNoStage(event : Event) : void
		{
			super.onNoStage(event);
		}

	}
}
