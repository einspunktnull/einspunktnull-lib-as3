package net.einspunktnull.thread
{
	/**
	 * @author Albrecht Nitsche
	 */
	public interface IRunnable
	{
		function process() : void;

		function get complete() : Boolean;

		function get total() : int;

		function get progress() : int;
	}
}
