package com.powerflasher.tlp.particles.twoD.zones 
{
    import flash.display.*;
    import flash.geom.*;
    import org.flintparticles.twoD.zones.*;
    
    public class UniqueBitmapDataZone extends Object implements org.flintparticles.twoD.zones.Zone2D
    {
        public function UniqueBitmapDataZone(arg1:flash.display.BitmapData, arg2:Number=0, arg3:Number=0, arg4:Number=0, arg5:Number=0)
        {
            super();
            this._bitmapData = arg1;
            this._left = arg4;
            this._top = arg5;
            this._pos = new flash.geom.Point(arg2, arg3);
            this.invalidate();
            return;
        }

        public function set y(arg1:Number):void
        {
            this._pos.y = arg1;
            return;
        }

        public function invalidate():void
        {
            var loc2:* =0;
            var loc3:* =0;
            this._width = this._bitmapData.width;
            this._height = this._bitmapData.height;
            this._right = this._left + this._width;
            this._bottom = this._top + this._height;
            this._validPoints = new Array();
            this._area = 0;
            var loc1:* =0;
            while (loc1 < this._width) 
            {
                loc2 = 0;
                while (loc2 < this._height) 
                {
                    loc3 = this._bitmapData.getPixel32(loc1, loc2);
                    if ((loc3 >> 24 & 255) != 0) 
                    {
                        var loc4:*;
                        var loc5:* =((loc4 = this)._area + 1);
                        loc4._area = loc5;
                        this._validPoints.push(new flash.geom.Point(loc1 + this._left, loc2 + this._top));
                    }
                    ++loc2;
                }
                ++loc1;
            }
            this._uniqueValidPoints = new Array();
            this._uniqueValidPoints = this._uniqueValidPoints.concat(this._validPoints);
            return;
        }

        public function getLocation():flash.geom.Point
        {
            if (this._uniqueValidPoints.length == 0) 
            {
                this._uniqueValidPoints = new Array();
                this._uniqueValidPoints = this._uniqueValidPoints.concat(this._validPoints);
            }
            var loc1:* =Math.round(Math.random() * (this._uniqueValidPoints.length - 1));
            var loc2:* =this._uniqueValidPoints.splice(loc1, 1)[0] as flash.geom.Point;
            return loc2.add(this._pos);
        }

        public function get yOffset():Number
        {
            return this._top;
        }

        public function getArea():Number
        {
            return this._area;
        }

        public function set xOffset(arg1:Number):void
        {
            this._left = arg1;
            this.invalidate();
            return;
        }

        public function set yOffset(arg1:Number):void
        {
            this._top = arg1;
            this.invalidate();
            return;
        }

        public function get xOffset():Number
        {
            return this._left;
        }

        public function contains(arg1:Number, arg2:Number):Boolean
        {
            var loc1:* =0;
            if (arg1 >= this._left && arg1 <= this._right && arg2 >= this._top && arg2 <= this._bottom) 
            {
                loc1 = this._bitmapData.getPixel32(Math.round(arg1 - this._left), Math.round(arg2 - this._top));
                return !((loc1 >> 24 & 255) == 0);
            }
            return false;
        }

        public function getColorForLocation(arg1:flash.geom.Point):uint
        {
            var loc1:* =arg1.subtract(this._pos);
            return this._bitmapData.getPixel32(loc1.x, loc1.y);
        }

        public function set bitmapData(arg1:flash.display.BitmapData):void
        {
            this._bitmapData = arg1;
            this.invalidate();
            return;
        }

        public function set x(arg1:Number):void
        {
            this._pos.x = arg1;
            return;
        }

        public function get bitmapData():flash.display.BitmapData
        {
            return this._bitmapData;
        }

        internal var _validPoints:Array;

        internal var _height:int;

        internal var _width:int;

        internal var _bottom:Number;

        internal var _pos:flash.geom.Point;

        internal var _top:Number;

        internal var _bitmapData:flash.display.BitmapData;

        internal var _right:Number;

        internal var _left:Number;

        internal var _area:Number;

        internal var _uniqueValidPoints:Array;
    }
}
