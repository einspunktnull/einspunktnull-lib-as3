package com.powerflasher.tlp.particles.twoD.initializers 
{
    import com.powerflasher.tlp.particles.twoD.*;
    import flash.geom.*;
    import org.flintparticles.common.emitters.*;
    import org.flintparticles.common.initializers.*;
    import org.flintparticles.common.particles.*;
    import org.flintparticles.twoD.particles.*;
    
    public class InitOnTarget extends org.flintparticles.common.initializers.InitializerBase
    {
        public function InitOnTarget()
        {
            super();
            return;
        }

        public override function initialize(arg1:org.flintparticles.common.emitters.Emitter, arg2:org.flintparticles.common.particles.Particle):void
        {
            var loc1:* =arg2 as org.flintparticles.twoD.particles.Particle2D;
            var loc2:* =loc1.dictionary[com.powerflasher.tlp.particles.twoD.ParticleConstants.TARGET_POSITION];
            loc1.x = loc2.x;
            loc1.y = loc2.y;
            return;
        }
    }
}
