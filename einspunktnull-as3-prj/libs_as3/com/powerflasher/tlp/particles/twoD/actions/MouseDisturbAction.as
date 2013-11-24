package com.powerflasher.tlp.particles.twoD.actions 
{
    import flash.display.*;
    import flash.events.*;
    import org.flintparticles.twoD.actions.*;
    
    public class MouseDisturbAction extends com.powerflasher.tlp.particles.twoD.actions.CombinedActionBase implements flash.events.IEventDispatcher
    {
        public function MouseDisturbAction(arg1:flash.display.DisplayObject)
        {
            super();
            this._dispatcher = new flash.events.EventDispatcher(this);
            var loc1:* =new com.powerflasher.tlp.particles.twoD.actions.TargetPositionGravity(600);
            loc1.addEventListener(com.powerflasher.tlp.particles.twoD.actions.TargetPositionGravity.REACHED_TARGET, this.onComplete);
            addAction(loc1);
            addAction(new org.flintparticles.twoD.actions.MouseAntiGravity(5, arg1, 5));
            addAction(new org.flintparticles.twoD.actions.Friction(400));
            return;
        }

        public function dispatchEvent(arg1:flash.events.Event):Boolean
        {
            return this._dispatcher.dispatchEvent(arg1);
        }

        public function removeEventListener(arg1:String, arg2:Function, arg3:Boolean=false):void
        {
            this._dispatcher.removeEventListener(arg1, arg2, arg3);
            return;
        }

        public function hasEventListener(arg1:String):Boolean
        {
            return this._dispatcher.hasEventListener(arg1);
        }

        public function willTrigger(arg1:String):Boolean
        {
            return this._dispatcher.willTrigger(arg1);
        }

        internal function onComplete(arg1:flash.events.Event):void
        {
            this.dispatchEvent(new flash.events.Event(flash.events.Event.COMPLETE));
            return;
        }

        public function addEventListener(arg1:String, arg2:Function, arg3:Boolean=false, arg4:int=0, arg5:Boolean=false):void
        {
            this._dispatcher.addEventListener(arg1, arg2, arg3, arg4, arg5);
            return;
        }

        internal var _dispatcher:flash.events.EventDispatcher;
    }
}
