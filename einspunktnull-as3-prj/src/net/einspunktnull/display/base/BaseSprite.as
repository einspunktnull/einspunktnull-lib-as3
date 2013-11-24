package net.einspunktnull.display.base
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author Albrecht Nitsche
	 */
	public class BaseSprite extends Sprite
	{
		
		public function BaseSprite()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}


		private function onAddedToStage(event : Event) : void
		{
			onStage(event);
			stage.addEventListener(Event.RESIZE, onResize);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}

		private function onRemovedFromStage(event : Event) : void
		{
			onNoStage(event);
			stage.removeEventListener(Event.RESIZE, onResize);
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}

		// override this if needed
		protected function onStage(event : Event) : void
		{
		}

		// override this if needed
		protected function onNoStage(event : Event) : void
		{
		}

		// override this if needed
		public function onResize(event : Event) : void
		{
		}
		
		// override this if needed
		protected function onMouseWheel(event : MouseEvent) : void
		{
		}
		
	}
}
