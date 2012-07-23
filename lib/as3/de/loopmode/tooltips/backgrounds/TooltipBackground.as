package de.loopmode.tooltips.backgrounds
{
	import de.loopmode.tooltips.Tooltip;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class TooltipBackground extends Sprite
	{
		protected var _borderRadius:Number;
		protected var _borderWidth:Number;
		protected var _borderColor:uint;
		protected var _borderAlpha:Number;
		protected var _bgColor:uint;
		protected var _bgAlpha:Number;
		
		protected var _width:Number;
		protected var _height:Number;
		
		private var _tooltip:Tooltip;
		public function get tooltip():Tooltip
		{
			return _tooltip;
		}
		public function TooltipBackground(bgColor:uint=0xFFFFFF, bgAlpha:Number=1, borderRadius:Number=0, borderWidth:Number=0, borderColor:uint=0x000000, borderAlpha:Number=0)
		{
			super();
			_bgColor = bgColor;
			_bgAlpha = bgAlpha;
			_borderRadius = borderRadius;
			_borderWidth = borderWidth;
			_borderColor = borderColor;
			_borderAlpha = borderAlpha;
		}
		
		public function draw(w:Number, h:Number):void
		{
			_width = w;
			_height = h;
			
			if (stage) {
				update();
			}
			else{
				addEventListener(Event.ADDED_TO_STAGE, update);
			}
		}
		
		protected function update(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, update);
			
			var w:Number = _width;
			var h:Number = _height;
			var g:Graphics = graphics;
			
			g.clear();
			if (_borderWidth) g.lineStyle(_borderWidth, _borderColor, _borderAlpha);
			g.beginFill(_bgColor, _bgAlpha);
			g.drawRoundRect(0, 0, w, h, _borderRadius, _borderRadius);
			g.endFill();
		}
		
		public function setTooltip(tip:Tooltip):void
		{
			_tooltip = tip;
		}
	}
}