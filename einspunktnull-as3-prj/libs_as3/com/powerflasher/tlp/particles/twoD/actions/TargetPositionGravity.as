package com.powerflasher.tlp.particles.twoD.actions 
{
    import com.powerflasher.tlp.particles.twoD.*;
    import flash.events.*;
    import flash.geom.*;
    import org.flintparticles.common.actions.*;
    import org.flintparticles.common.emitters.*;
    import org.flintparticles.common.events.*;
    import org.flintparticles.common.particles.*;
    import org.flintparticles.twoD.particles.*;
    
    public class TargetPositionGravity extends org.flintparticles.common.actions.ActionBase implements flash.events.IEventDispatcher
    {
        public function TargetPositionGravity(arg1:Number, arg2:Number=100)
        {
            super();
            this._dispatcher = new flash.events.EventDispatcher(this);
            this._power = arg1 * this._gravityConst;
            this._epsilonSq = arg2 * arg2;
            this._pos = new flash.geom.Point();
            return;
        }

        public function dispatchEvent(arg1:flash.events.Event):Boolean
        {
            return this._dispatcher.dispatchEvent(arg1);
        }

        public function get power():Number
        {
            return this._power / this._gravityConst;
        }

        public override function update(arg1:org.flintparticles.common.emitters.Emitter, arg2:org.flintparticles.common.particles.Particle, arg3:Number):void
        {
            var loc1:*;
            if ((loc1 = org.flintparticles.twoD.particles.Particle2D(arg2)).dictionary[com.powerflasher.tlp.particles.twoD.ParticleConstants.TARGET_POSITION] == null) 
            {
                return;
            }
            var loc2:*;
            var loc3:* =(loc2 = loc1.dictionary[com.powerflasher.tlp.particles.twoD.ParticleConstants.TARGET_POSITION]).x - loc1.x;
            var loc4:* =loc2.y - loc1.y;
            var loc5:*;
            if ((loc5 = loc3 * loc3 + loc4 * loc4) < 0.5) 
            {
                loc1.velX = 0;
                loc1.velY = 0;
                loc1.x = loc2.x;
                loc1.y = loc2.y;
                var loc8:*;
                var loc9:* =((loc8 = this)._doneCount + 1);
                loc8._doneCount = loc9;
                if (this._doneCount == arg1.particles.length && !this._hasDispatched) 
                {
                    this.dispatchEvent(new flash.events.Event(REACHED_TARGET));
                    this._hasDispatched = true;
                }
                return;
            }
            this._hasDispatched = false;
            var loc6:* =Math.sqrt(loc5);
            if (loc5 < this._epsilonSq) 
            {
                loc5 = this._epsilonSq;
            }
            var loc7:* =this._power * arg3 / (loc5 * loc6);
            loc1.velX = loc1.velX + loc3 * loc7;
            loc1.velY = loc1.velY + loc4 * loc7;
            return;
        }

        public function set power(arg1:Number):void
        {
            this._power = arg1 * this._gravityConst;
            return;
        }

        public function removeEventListener(arg1:String, arg2:Function, arg3:Boolean=false):void
        {
            this._dispatcher.removeEventListener(arg1, arg2, arg3);
            return;
        }

        public override function addedToEmitter(arg1:org.flintparticles.common.emitters.Emitter):void
        {
            this._emitter = arg1;
            arg1.addEventListener(org.flintparticles.common.events.EmitterEvent.EMITTER_UPDATED, this.onEmitterUpdate, false, 0, true);
            super.addedToEmitter(arg1);
            return;
        }

        public function set epsilon(arg1:Number):void
        {
            this._epsilonSq = arg1 * arg1;
            return;
        }

        public function addEventListener(arg1:String, arg2:Function, arg3:Boolean=false, arg4:int=0, arg5:Boolean=false):void
        {
            this._dispatcher.addEventListener(arg1, arg2, arg3, arg4, arg5);
            return;
        }

        public function get epsilon():Number
        {
            return Math.sqrt(this._epsilonSq);
        }

        public function hasEventListener(arg1:String):Boolean
        {
            return this._dispatcher.hasEventListener(arg1);
        }

        internal function onEmitterUpdate(arg1:org.flintparticles.common.events.EmitterEvent):void
        {
            this._doneCount = 0;
            return;
        }

        public function willTrigger(arg1:String):Boolean
        {
            return this._dispatcher.willTrigger(arg1);
        }

        public static const REACHED_TARGET:String="REACHED_TARGET";

        internal var _power:Number;

        internal var _dispatcher:flash.events.EventDispatcher;

        internal var _pos:flash.geom.Point;

        internal var _gravityConst:Number=10000;

        internal var _epsilonSq:Number;

        internal var _hasDispatched:Boolean=true;

        internal var _doneCount:int;

        internal var _emitter:org.flintparticles.common.emitters.Emitter;
    }
}
