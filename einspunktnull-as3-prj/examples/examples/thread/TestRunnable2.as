package examples.thread
{
	import net.einspunktnull.thread.IRunnable;

	/**
	 * @author Albrecht Nitsche
	 */
	public class TestRunnable2 implements IRunnable
	{
		private var _random : uint;
		private var _complete : Boolean = false;
		private var _max : int;
		private var _rounds : int;

		public function TestRunnable2()
		{
			_max = 10000000;
			_rounds = 1000000;
			_random = uint(Math.random() * _max);
		}

		public function process() : void
		{
			for (var i : int = 0; i < _rounds; i++)
			{
				if (uint(Math.random() * _max) == _random)
				{
					_complete = true;
					break;
				}
			}
		}

		public function get complete() : Boolean
		{
			return _complete;
		}

		public function get total() : int
		{
			return 0;
		}

		public function get progress() : int
		{
			return 0;
		}
	}
}
