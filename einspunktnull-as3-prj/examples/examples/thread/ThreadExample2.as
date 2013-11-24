package examples.thread
{
	import net.einspunktnull.display.util.DisplayObjectUtil;
	import net.einspunktnull.thread.IRunnable;
	import net.einspunktnull.thread.Thread;
	import net.einspunktnull.thread.ThreadEvent;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Albrecht Nitsche
	 */
	public class ThreadExample2 extends Sprite
	{

		// THREAD
		private var _runnable : IRunnable;
		private var _thread : Thread;
		private var _shape : Shape;

		public function ThreadExample2()
		{

			_shape = new Shape();
			_shape.graphics.beginFill(0xff0000);
			_shape.graphics.drawRect(-50, -50, 100, 100);
			addChild(_shape);
			DisplayObjectUtil.center(_shape, stage);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);

			_runnable = new TestRunnable2();

			_thread = new Thread(_runnable, "Test2", 1000/stage.frameRate);
			_thread.addEventListener(ThreadEvent.PROGRESS, onThreadEvent);
			_thread.addEventListener(ThreadEvent.ERROR, onThreadEvent);
			_thread.addEventListener(ThreadEvent.COMPLETE, onThreadEvent);
			_thread.start();

		}

		private function onEnterFrame(event : Event) : void
		{
			_shape.rotation += 10;
			_shape.rotation = _shape.rotation >= 360 ? 0 : _shape.rotation;
		}


		private function onThreadEvent(event : ThreadEvent) : void
		{
			switch(event.type)
			{
				case ThreadEvent.ERROR:
					destroy();
					break;
				case ThreadEvent.PROGRESS:
					break;
				case ThreadEvent.COMPLETE:
					logch("ready");
					destroy();
					break;
			}
		}

		private function destroy() : void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			_shape.scaleX = _shape.scaleY = 0.5;
			_thread.destroy();
			_thread.removeEventListener(ThreadEvent.PROGRESS, onThreadEvent);
			_thread.removeEventListener(ThreadEvent.ERROR, onThreadEvent);
			_thread.removeEventListener(ThreadEvent.COMPLETE, onThreadEvent);
			_thread = null;
		}
	}
}
