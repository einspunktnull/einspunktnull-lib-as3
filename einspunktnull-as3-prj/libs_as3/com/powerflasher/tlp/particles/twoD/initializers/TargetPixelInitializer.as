package com.powerflasher.tlp.particles.twoD.initializers 
{
    import com.powerflasher.tlp.particles.twoD.*;
    import com.powerflasher.tlp.particles.twoD.zones.*;
    import flash.geom.*;
    import org.flintparticles.common.emitters.*;
    import org.flintparticles.common.initializers.*;
    import org.flintparticles.common.particles.*;
    import org.flintparticles.twoD.particles.*;
    
    public class TargetPixelInitializer extends org.flintparticles.common.initializers.InitializerBase
    {
        public function TargetPixelInitializer(arg1:com.powerflasher.tlp.particles.twoD.zones.UniqueBitmapDataZone)
        {
            super();
            this._zone = arg1;
            return;
        }

        public override function initialize(arg1:org.flintparticles.common.emitters.Emitter, arg2:org.flintparticles.common.particles.Particle):void
        {
            super.initialize(arg1, arg2);
            var loc1:* =arg2 as org.flintparticles.twoD.particles.Particle2D;
            var loc2:* =this._zone.getLocation();
            loc1.dictionary[com.powerflasher.tlp.particles.twoD.ParticleConstants.TARGET_POSITION] = loc2;
            loc1.color = this._zone.getColorForLocation(loc2);
            return;
        }

        internal var _zone:com.powerflasher.tlp.particles.twoD.zones.UniqueBitmapDataZone;
    }
}
