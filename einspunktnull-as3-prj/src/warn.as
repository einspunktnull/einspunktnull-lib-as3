package
{
	import net.einspunktnull.utils.setOrApply;

	/**
	 * @author Albrecht Nitsche
	 */
	public function warn(...args) : void
	{
		var params : Array = args.slice(0, args.length);
		params.unshift(null, "com.junkbyte.console.Cc", "warn");
		if (!setOrApply.apply(null, params)) trace("#warn#", args);
	}
}
