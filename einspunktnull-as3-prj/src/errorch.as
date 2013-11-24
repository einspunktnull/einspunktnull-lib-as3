package
{
	import net.einspunktnull.utils.objName;
	import net.einspunktnull.utils.setOrApply;

	/**
	 * @author Albrecht Nitsche
	 */
	public function errorch(channel : Object, ...args) : void
	{
		var params : Array = args.slice(0, args.length);
		params.unshift(null, "com.junkbyte.console.Cc", "errorch", channel);
		var channelName : String = objName(channel);
		if (!setOrApply.apply(null, params)) trace("#errorch#","[" + channelName + "]", args);
	}
}
