package net.einspunktnull.components.ui.progressbar
{
	import flash.display.Sprite;

	/**
	 * @author Albrecht Nitsche
	 */
	public class ProgressBar extends Sprite
	{
		private var _progressBarAsset : ProgressBarAsset;

		public function ProgressBar(progressBarAsset : ProgressBarAsset)
		{
			_progressBarAsset = progressBarAsset;

			addChild(_progressBarAsset.background);
			addChild(_progressBarAsset.bar);
			addChild(_progressBarAsset.border);

			value = 0;
		}

		public function set value(value : Number) : void
		{
			_progressBarAsset.bar.width = value * width;
		}

		public function get value() : Number
		{
			return _progressBarAsset.bar.width / width;
		}
	}
}
