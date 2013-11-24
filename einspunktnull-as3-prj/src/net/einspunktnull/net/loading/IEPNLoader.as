package net.einspunktnull.net.loading
{
	import flash.events.IEventDispatcher;

	/**
	 * @author Albrecht Nitsche
	 */
	public interface IEPNLoader extends IEventDispatcher
	{

		function load(url : String = null) : void;

		function get content() : *;
		

	}
}
