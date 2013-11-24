package examples.thread
{
	import net.einspunktnull.components.ui.progressbar.ProgressBar;
	import net.einspunktnull.components.ui.progressbar.ProgressBarAsset;
	import net.einspunktnull.display.util.DisplayObjectUtil;
	import net.einspunktnull.thread.IRunnable;
	import net.einspunktnull.thread.Thread;
	import net.einspunktnull.thread.ThreadEvent;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.ProgressEvent;

	/**
	 * @author Albrecht Nitsche
	 */
	public class ThreadExample extends Sprite
	{
		// UI
		[Embed(source="examples/thread/assets/pb_background.png")]
		private var ProgressBarBackground : Class;
		[Embed(source="examples/thread/assets/pb_bar.png")]
		private var ProgressBarBar : Class;
		[Embed(source="examples/thread/assets/pb_border.png")]
		private var ProgressBarBorder : Class;
		private var _progressBar : ProgressBar;

		// THREAD
		private var _runnable : IRunnable;
		private var _thread : Thread;

		public function ThreadExample()
		{
			_progressBar = createProgressBar();
			addChild(_progressBar);
			DisplayObjectUtil.center(_progressBar, stage);

			_runnable = new TestRunnable();

			_thread = new Thread(_runnable, "Test", 200);
			_thread.addEventListener(ThreadEvent.PROGRESS, onThreadEvent);
			_thread.addEventListener(ThreadEvent.ERROR, onThreadEvent);
			_thread.addEventListener(ThreadEvent.COMPLETE, onThreadEvent);
			_thread.start();

		}

		private function createProgressBar() : ProgressBar
		{
			var pbasset : ProgressBarAsset = new ProgressBarAsset();
			pbasset.background = new ProgressBarBackground as Bitmap;
			pbasset.bar = new ProgressBarBar as Bitmap;
			pbasset.border = new ProgressBarBorder();
			return new ProgressBar(pbasset);
		}

		private function onThreadEvent(event : ThreadEvent) : void
		{
			logch(this, event, event.type, event.data);
			switch(event.type)
			{
				case ThreadEvent.ERROR:
					logch("error");
					destroy();
					break;
				case ThreadEvent.PROGRESS:
					logch("progress");
					_progressBar.value = ProgressEvent(event.data).bytesLoaded / ProgressEvent(event.data).bytesTotal;
					break;
				case ThreadEvent.COMPLETE:
					logch("ready");
					_progressBar.value = 1;
					destroy();
					break;
			}
		}

		private function destroy() : void
		{
			_thread.destroy();
			_thread.removeEventListener(ThreadEvent.PROGRESS, onThreadEvent);
			_thread.removeEventListener(ThreadEvent.ERROR, onThreadEvent);
			_thread.removeEventListener(ThreadEvent.COMPLETE, onThreadEvent);
			_thread = null;
		}
	}
}
