package net.einspunktnull.addon.puremvc.patterns.controller
{
	import net.einspunktnull.addon.puremvc.patterns.model.EPNProxy;
	import net.einspunktnull.addon.puremvc.patterns.model.vo.EPNStartupVO;
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;


	/**
	 * @author Albrecht Nitsche
	 */
	public class EPNSimpleCommand extends SimpleCommand implements ICommand
	{
		protected var _startupVO : EPNStartupVO;

		override public function execute(notification : INotification) : void
		{
			_startupVO = notification.getBody() as EPNStartupVO;
			facade.registerProxy(new EPNProxy(EPNProxy.NAME, _startupVO));
		}
	}
}
