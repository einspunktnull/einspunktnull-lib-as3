package
{
	import net.einspunktnull.utils.objName;
	import net.einspunktnull.utils.setOrApply;

	/**
	 * @author Albrecht Nitsche
	 */
	public function infoch(channel : Object, ...args) : void
	{
		var params : Array = args.slice(0, args.length);
		params.unshift(null, "com.junkbyte.console.Cc", "infoch", channel);
		var channelName : String = objName(channel);
		if (!setOrApply.apply(null, params)) trace("#infoch#","[" + channelName + "]", args);
	}
}
