package net.einspunktnull.thread
{
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	[Event(name="complete", type="net.einspunktnull.thread.ThreadEvent")]

	[Event(name="error", type="net.einspunktnull.thread.ThreadEvent")]

	[Event(name="progress", type="net.einspunktnull.thread.ThreadEvent")]

	/**
	 * @author Albrecht Nitsche
	 */
	public class Thread extends EventDispatcher
	{
		private var _timer : Timer;
		private var _runnable : IRunnable;
		private var _threadName : String;
		private var _maxRunTimes : int = 0;
		private var _totalTimesRan : int = 0;

		public function Thread(runnable : IRunnable, threadName : String, delay : Number = 200, timeOut : Number = -1)
		{
			_runnable = runnable;
			_threadName = threadName;

			if (timeOut != -1)
			{
				if (timeOut < delay)
				{
					throw new Error("delay must be equal or smaller than timeOut");
				}
				_maxRunTimes = Math.ceil(timeOut / delay);
			}

			_timer = new Timer(delay, _maxRunTimes);
			_timer.addEventListener(TimerEvent.TIMER, processor);
		}

		public function destroy() : void
		{
			if (_timer)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, processor);
				_timer = null;
			}
			if (_runnable) _runnable = null;
		}

		private function processor(event : TimerEvent) : void
		{
			try
			{
				_runnable.process();
				_totalTimesRan++;
			}
			catch(error : Error)
			{
				destroy();
				var msgError : String = "Thread [" + _threadName + "] encountered an error while" + " calling the IRunnable.process() method: " + error.message;
				dispatchEvent(new ThreadEvent(ThreadEvent.ERROR, false, false, msgError, error));
				return;
			}

			if (_runnable.complete)
			{
				dispatchEvent(new ThreadEvent(ThreadEvent.COMPLETE, false, false));
				destroy();
			}
			else if (_maxRunTimes != 0 && _maxRunTimes == _totalTimesRan)
			{
				destroy();
				var msgErrorTimeout : String = "Thread [" + _threadName + "] " + "timeout exceeded before IRunnable reported complete";
				dispatchEvent(new ThreadEvent(ThreadEvent.ERROR, false, false, msgErrorTimeout, new Error(msgErrorTimeout)));
				return;
			}
			else
			{
				var progressEvent : ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS, false, false, _runnable.progress, _runnable.total);
				dispatchEvent(new ThreadEvent(ThreadEvent.PROGRESS, false, false, "Progress Ratio: " + _runnable.progress / _runnable.total, progressEvent));
			}
		}

		public function start() : void
		{
			_timer.start();
		}
	}
}
