package net.einspunktnull.addon.puremvc.patterns.core
{
	import net.einspunktnull.addon.puremvc.patterns.model.vo.EPNStartupVO;

	/**
	 * @author Albrecht Nitsche
	 */
	public interface IEPNApplication
	{
		function start(startupVO : EPNStartupVO) : void;
	}
}
