package
net.einspunktnull.utils{
	import flash.display.DisplayObjectContainer;

	/**
	 * @author Albrecht Nitsche
	 */
	public function getFlashvars(container : DisplayObjectContainer, name : String) : String
	{
		return container.root.loaderInfo.parameters[name];
	}
}
