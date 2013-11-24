package com.powerflasher.tlp.particles.twoD.actions 
{
    import org.flintparticles.common.actions.*;
    import org.flintparticles.common.emitters.*;
    import org.flintparticles.common.particles.*;
    
    public class CombinedActionBase extends org.flintparticles.common.actions.ActionBase
    {
        public function CombinedActionBase()
        {
            super();
            this._actions = new Array();
            return;
        }

        public override function addedToEmitter(arg1:org.flintparticles.common.emitters.Emitter):void
        {
            var loc1:* =null;
            var loc2:* =0;
            var loc3:* =this._actions;
            for each (loc1 in loc3) 
            {
                loc1.addedToEmitter(arg1);
            }
            return;
        }

        protected function addAction(arg1:org.flintparticles.common.actions.Action):void
        {
            this._actions.push(arg1);
            return;
        }

        public override function update(arg1:org.flintparticles.common.emitters.Emitter, arg2:org.flintparticles.common.particles.Particle, arg3:Number):void
        {
            var loc1:* =null;
            var loc2:* =0;
            var loc3:* =this._actions;
            for each (loc1 in loc3) 
            {
                loc1.update(arg1, arg2, arg3);
            }
            return;
        }

        internal var _actions:Array;
    }
}
