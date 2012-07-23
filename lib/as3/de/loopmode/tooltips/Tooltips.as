package de.loopmode.tooltips
{
	import de.loopmode.tooltips.backgrounds.TooltipBackground;
	
	import flash.display.DisplayObject;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;

	public class Tooltips
	{
		
		private static var tips:Dictionary = new Dictionary();
		
		public function Tooltips()
		{
		}
		
		public static function createTip(target:DisplayObject, text:String, position:*=null, format:TextFormat = null, bg:TooltipBackground = null, xOffset:Number=0, yOffset:Number=0):Tooltip
		{
			var tt:Tooltip = tips[target];

			if (tt) {
				tt.destroy();
			}
			
			if (text === null) {
				delete tips[target];
				return null;
			}
			
			tt = new Tooltip(target, text, position, format, bg, xOffset, yOffset);
			tips[target] = tt;
			return tt;
		}
		
		public static function destroyTip(target:DisplayObject):void
		{
			var tt:Tooltip = tips[target];
			if (tt) {
				tt.destroy();
			}
			delete tips[target];
		}
		
		public static function setText(target:DisplayObject, value:String):void
		{
			var tt:Tooltip = tips[target];
			if (tt) {
				tt.text = value;
			}
		}
		
		public static function hideTip(target:DisplayObject):void
		{
			var tt:Tooltip = tips[target];
			if (tt) {
				tt.hide();
			}
		}
	}
}