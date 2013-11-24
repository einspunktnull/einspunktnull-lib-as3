package net.einspunktnull.addon.puremvc.patterns.core
{
	import net.einspunktnull.addon.puremvc.patterns.facade.EPNFacade;
	import net.einspunktnull.addon.puremvc.patterns.model.vo.EPNStartupVO;
	import net.einspunktnull.addon.puremvc.patterns.view.vc.EPNCanvasVC;
	import net.einspunktnull.display.base.ApplicationSprite;

	/**
	 * @author Albrecht Nitsche
	 */
	public class EPNApplication extends ApplicationSprite
	{
		private var _canvas : EPNCanvasVC;

		public function EPNApplication(appName : String = null)
		{
			super(appName);
		}

		public function startup(startupVO : EPNStartupVO, facade : EPNFacade) : void
		{
			_canvas = startupVO.canvas;
			if (_canvas) addChild(_canvas);
			if (!facade) facade = EPNFacade.getInstance(_appName);
			facade.startup(startupVO);
		}
	}
}
