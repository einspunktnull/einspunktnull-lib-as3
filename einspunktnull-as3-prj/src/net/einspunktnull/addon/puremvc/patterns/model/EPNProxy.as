package net.einspunktnull.addon.puremvc.patterns.model
{
	import net.einspunktnull.addon.puremvc.patterns.model.vo.EPNStartupVO;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;


	/**
	 * @author Albrecht Nitsche
	 */
	public class EPNProxy extends Proxy implements IProxy
	{
		public static const NAME : String = "EPNProxy";
		protected var _startupVO : EPNStartupVO;

		public function EPNProxy(proxyName : String, startupVO : EPNStartupVO)
		{
			super(proxyName);
			_startupVO = startupVO;
		}

		public function get startupVO() : EPNStartupVO
		{
			return _startupVO;
		}
	}
}
