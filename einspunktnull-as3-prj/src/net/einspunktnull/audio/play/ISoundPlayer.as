package net.einspunktnull.audio.play
{
	import com.gskinner.motion.GTween;
	/**
	 * @author Albrecht Nitsche
	 */
	public interface ISoundPlayer
	{
		function assignVolume() : void;

		function toggleVolume() : void;

		function reset() : void;

		function play(soundPlayerID:String = "") : void;

		function pause(soundPlayerID:String = "") : void;

		function stop(soundPlayerID:String = "") : void;

		function fade(volume : Number, time : Number) : void;
		
		function applySoundTransform(tween:GTween=null):void;
		
		function get volume():Number;
		
		function set volume(volume:Number):void;
	}
}
