package net.einspunktnull.typography.fx.particletext
{
	import net.einspunktnull.bitmap.util.BitmapUtil;
	import net.einspunktnull.typography.fx.ITFX;
	import net.einspunktnull.typography.fx.ITFXParams;
	import net.einspunktnull.typography.fx.TFX;

	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.powerflasher.tlp.particles.twoD.emitter.MouseDisturb;
	import com.powerflasher.tlp.particles.twoD.zones.UniqueBitmapDataZone;

	import org.flintparticles.common.events.EmitterEvent;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.renderers.PixelRenderer;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;




	/**
	 * @author Albrecht Nitsche
	 */
	public class TFXParticleText extends TFX implements ITFX
	{
		private var _bitmapData : BitmapData;
		private var backgroundBitmap : Bitmap;
		private var zone : UniqueBitmapDataZone;
		private var displayBitmap : Bitmap;
		private var _emitter : Emitter2D;
		private var _renderer : PixelRenderer;
		private var _enabled : Boolean = true;

		public function TFXParticleText(textField : TextField, params : ITFXParams = null)
		{
			if (params == null) params = new TFXParticleTextParams();
			super(textField, params);
			_bitmapData = BitmapUtil.snapshot(this.textField).bitmapData;
			// _bitmapData = BitmapUtil.createBitmapData(this.textField, true);
			TweenPlugin.activate([AutoAlphaPlugin]);
			TweenPlugin.activate([TintPlugin]);
			updateUI();
			applyListener();
			enableEmitter();
		}

		private function updateUI() : void
		{
			if (this.bitmapData == null)
			{
				return;
			}
			this.cleanUpUi();
			this.zone = new UniqueBitmapDataZone(this.bitmapData);
			this.displayBitmap = new Bitmap(this.bitmapData);
			this.backgroundBitmap = new Bitmap(this.bitmapData);
			TweenLite.to(this.backgroundBitmap, 0, {tint:11184810});
			addChild(this.backgroundBitmap);
			addChild(this.displayBitmap);
			backgroundBitmap.visible = false;
			displayBitmap.visible = false;
			this.drawHitarea();
		}

		private function cleanUpUi() : void
		{
			this.disableEmitter();
			if (!(this.backgroundBitmap == null) && contains(this.backgroundBitmap))
			{
				removeChild(this.backgroundBitmap);
			}
			if (!(this.displayBitmap == null) && contains(this.displayBitmap))
			{
				removeChild(this.displayBitmap);
			}
		}

		private function disableEmitter() : void
		{
			if (this._emitter == null)
			{
				return;
			}
			this._emitter.addEventListener(EmitterEvent.EMITTER_UPDATED, this.stopEmitter);
		}

		private function drawHitarea() : void
		{
			graphics.clear();
			graphics.beginFill(0xff0000, 0);
			graphics.drawRect(0, 0, width, height);
		}

		private function stopEmitter(event : EmitterEvent = null) : void
		{
			this._emitter.stop();
			this._emitter = null;
			removeChild(this._renderer as DisplayObject);
			this._renderer = null;
		}

		private function applyListener() : void
		{
			addEventListener(MouseEvent.ROLL_OVER, this.handleRollOver);
		}

		private function handleRollOver(event : MouseEvent) : void
		{
			if (this.enabled)
			{
				TweenLite.to(this.displayBitmap, 0.2, {"autoAlpha":0});
				this.enableEmitter();
			}
		}

		private function enableEmitter() : void
		{
			var w : Number = 0;
			var h : Number = 0;
			if (this._renderer == null)
			{
				w = width + 30;
				h = height + 30;
				this._renderer = new PixelRenderer(new Rectangle(-15, -15, w, h));
				addChild(this._renderer);
			}
			if (this._emitter == null)
			{
				this._emitter = new MouseDisturb(this.zone, this._renderer);
				this._emitter.addEventListener(MouseDisturb.COMPLETE, this.handleMouseDisturbComplete, false, 0, true);
				this._renderer.addEmitter(this._emitter);
				this._emitter.start();
			}
			return;
		}

		public function start() : void
		{
		}

		public function get bitmapData() : BitmapData
		{
			return _bitmapData;
		}

		internal function handleMouseDisturbComplete(arg1 : Event) : void
		{
			TweenLite.to(this.displayBitmap, 0, {autoAlpha:1});
			this.disableEmitter();
			return;
		}

		public function get enabled() : Boolean
		{
			return _enabled;
		}

		public function set enabled(enabled : Boolean) : void
		{
			_enabled = enabled;
		}
	}
}
