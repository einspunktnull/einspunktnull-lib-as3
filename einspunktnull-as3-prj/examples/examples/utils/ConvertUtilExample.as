package
examples.utils{
	import net.einspunktnull.data.util.ConvertUtil;

	import flash.display.Sprite;

	/**
	 * @author Albrecht Nitsche
	 */
	public class ConvertUtilExample extends Sprite
	{
		public function ConvertUtilExample()
		{

			log(ConvertUtil.filesize(4100));

		}
	}
}
