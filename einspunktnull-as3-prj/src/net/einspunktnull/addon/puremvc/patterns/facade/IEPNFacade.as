package net.einspunktnull.addon.puremvc.patterns.facade
{
	/**
	 * @author Albrecht Nitsche
	 */
	public interface IEPNFacade
	{
		function get shutdownCommand() : Class;

		function get startupCommand() : Class;
	}
}
