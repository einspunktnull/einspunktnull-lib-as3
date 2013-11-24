package com.powerflasher.tlp.particles.twoD.emitter 
{
    import com.powerflasher.tlp.particles.twoD.actions.*;
    import com.powerflasher.tlp.particles.twoD.initializers.*;
    import com.powerflasher.tlp.particles.twoD.zones.*;
    import flash.display.*;
    import flash.events.*;
    import org.flintparticles.common.counters.*;
    import org.flintparticles.common.displayObjects.*;
    import org.flintparticles.common.initializers.*;
    import org.flintparticles.twoD.actions.*;
    import org.flintparticles.twoD.emitters.*;
    
    public class MouseDisturb extends org.flintparticles.twoD.emitters.Emitter2D
    {
        public function MouseDisturb(arg1:com.powerflasher.tlp.particles.twoD.zones.UniqueBitmapDataZone, arg2:flash.display.DisplayObject)
        {
            super();
            counter = new org.flintparticles.common.counters.Blast(arg1.getArea());
            addInitializer(new org.flintparticles.common.initializers.ImageClass(org.flintparticles.common.displayObjects.Dot, 1));
            addInitializer(new com.powerflasher.tlp.particles.twoD.initializers.TargetPixelInitializer(arg1));
            addInitializer(new com.powerflasher.tlp.particles.twoD.initializers.InitOnTarget());
            var loc1:* =new com.powerflasher.tlp.particles.twoD.actions.MouseDisturbAction(arg2);
            loc1.addEventListener(flash.events.Event.COMPLETE, this.handleActionComplete);
            addAction(loc1, -100);
            addAction(new org.flintparticles.twoD.actions.Move());
            return;
        }

        internal function handleActionComplete(arg1:flash.events.Event):void
        {
            dispatchEvent(new flash.events.Event(COMPLETE));
            return;
        }

        public static const COMPLETE:String="COMPLETE";
    }
}
