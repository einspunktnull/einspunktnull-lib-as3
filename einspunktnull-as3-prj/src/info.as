package
{
	import net.einspunktnull.utils.setOrApply;

	/**
	 * @author Albrecht Nitsche
	 */
	public function info(...args) : void
	{
		var params : Array = args.slice(0, args.length);
		params.unshift(null, "com.junkbyte.console.Cc", "info");
		if (!setOrApply.apply(null, params)) trace("#info#",args);
	}
}
