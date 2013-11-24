package net.einspunktnull.addon.puremvc.patterns.facade
{
	import net.einspunktnull.addon.puremvc.patterns.controller.EPNStartUpMacroCommand;
	import net.einspunktnull.addon.puremvc.patterns.model.vo.EPNStartupVO;
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import org.puremvc.as3.multicore.patterns.facade.Facade;




	/**
	 * @author Albrecht Nitsche
	 */
	public class EPNFacade extends Facade implements IFacade
	{

		public static const STARTUP : String = "startup";

		public function EPNFacade(key : String)
		{
			super(key);
		}

		public static function getInstance(key : String) : EPNFacade
		{
			if ( instanceMap[ key ] == null ) instanceMap[ key ] = new EPNFacade(key);
			return instanceMap[ key ];
		}

		override protected function initializeController() : void
		{
			super.initializeController();
			registerCommand(STARTUP, startupCommand);
		}

		public function startup(startupVO : EPNStartupVO) : void
		{
			sendNotification(STARTUP, startupVO);
		}

		public function get startupCommand() : Class
		{
			return EPNStartUpMacroCommand;
		}

		public function get shutdownCommand() : Class
		{
			return null;
		}

	}
}
