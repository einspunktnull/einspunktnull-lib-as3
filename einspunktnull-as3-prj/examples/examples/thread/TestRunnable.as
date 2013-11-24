package examples.thread
{
	import net.einspunktnull.thread.IRunnable;

	/**
	 * @author Albrecht Nitsche
	 */
	public class TestRunnable implements IRunnable
	{
		private var counter : int = 0;
		private var totalToReach : int = 100;

		public function process() : void
		{
			counter++;
		}

		public function get complete() : Boolean
		{
			return counter == totalToReach;
		}

		public function get total() : int
		{
			return this.totalToReach;
		}

		public function get progress() : int
		{
			return this.counter;
		}
	}
}
