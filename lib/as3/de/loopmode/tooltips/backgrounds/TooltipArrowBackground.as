package de.loopmode.tooltips.backgrounds
{
	
	import flash.display.Graphics;
	import flash.events.Event;
	import de.loopmode.tooltips.Tooltip;
	
	public class TooltipArrowBackground extends de.loopmode.tooltips.backgrounds.TooltipBackground
	{
		private var _arrowWidth:Number = 7;
		private var _arrowHeight:Number = 7;
		
		public function TooltipArrowBackground()
		{
			super(0x259FE2, 1, 10);
		}
		override protected function update(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, update);
			
			var w:Number = _width;
			var h:Number = _height;
			var g:Graphics = graphics;
			
			g.clear(); 
			g.beginFill(_bgColor, 0.95);
			
			// arrow
			switch (tooltip.position) {
				
				case Tooltip.POSITION_RIGHT:
					// arrow to the left side
					if (tooltip.textFieldOffsetX != arrowWidth) {
						tooltip.textFieldOffsetX = arrowWidth;
						tooltip.textField.x += arrowWidth
					}
					
					g.moveTo(0, h*0.5);
					g.lineTo(arrowWidth, 0.5*(h-arrowHeight));
					g.lineTo(arrowWidth, h - 0.5*(h-arrowHeight));
					g.lineTo(0,h*0.5);
					g.drawRoundRect(arrowWidth,0,w,h,_borderRadius,_borderRadius);
					break;
				
				case Tooltip.POSITION_LEFT:
					// arrow to the right side
					g.drawRoundRect(0,0,w,h,_borderRadius,_borderRadius);
					g.moveTo(w, 0.5*(h-arrowHeight));
					g.lineTo(w+arrowWidth, h/2);
					g.lineTo(w, h - 0.5*(h-arrowHeight));
					break;
				
				
				case Tooltip.POSITION_TOP:
					// arrow to the bottom side
					g.drawRoundRect(0,0,w,h,_borderRadius,_borderRadius);
					g.moveTo(w*0.5, arrowHeight+h);
					g.lineTo(w*0.5 - arrowWidth*0.5, h);
					g.lineTo(w*0.5 + arrowWidth*0.5, h);
					break;
				
				case Tooltip.POSITION_BOTTOM:
					// arrow to the top side
					if (tooltip.textFieldOffsetY != arrowHeight) {
						tooltip.textFieldOffsetY = arrowHeight;
						tooltip.textField.y += arrowHeight
					}
					g.drawRoundRect(0,arrowHeight,w,h,_borderRadius,_borderRadius);
					g.moveTo(w*0.5, 0);
					g.lineTo(w*0.5 - arrowWidth*0.5, arrowHeight);
					g.lineTo(w*0.5 + arrowWidth*0.5, arrowHeight);
					break;
			}
			
			
			g.endFill();
		}
		
		public function get arrowWidth():Number
		{
			return _arrowWidth;
		}
		public function get arrowHeight():Number
		{
			return _arrowHeight;
		}
	}
}