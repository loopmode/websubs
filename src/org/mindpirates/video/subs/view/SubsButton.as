package org.mindpirates.video.subs.view
{
	import com.greensock.TweenLite;
	
	import de.loopmode.tooltips.Tooltip;
	import de.loopmode.tooltips.Tooltips;
	import de.loopmode.tooltips.backgrounds.TooltipArrowBackground;
	
	import embed.fonts.EmbeddedFonts;
	
	import fl.controls.Button;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import org.mindpirates.video.subs.Subtitles;
	
	public class SubsButton extends Button
	{
		/*
		public var tooltipText:String = "this is a tooltip";
		public var tooltip:Sprite;
		public var tooltipHilightColor:uint = 0x259FE2;
		*/
		private var _tooltip:String;
		
		public var tf:TextField;
		private var defaultAlpha:Number = 1;
		
		
		public function SubsButton()
		{
			super();

			label = '';
			
			var fmt:TextFormat = new TextFormat();
			fmt.color = 0xffffff;
			fmt.font = EmbeddedFonts.UNI_05_53;
			
			tf = new TextField();
			tf.name = 'tf';
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.embedFonts = true;
			tf.defaultTextFormat = fmt;
			addChild(tf);
			
			alpha = defaultAlpha;
			
			useHandCursor = true;
			buttonMode = true;
			
			addEventListener(MouseEvent.ROLL_OVER, handleRollOver);
			addEventListener(MouseEvent.ROLL_OUT, handleRollOut);
			addEventListener(MouseEvent.CLICK, handleClick);
		}
		
		protected function handleClick(event:MouseEvent):void
		{
		}		
		
		protected function handleRollOver(event:MouseEvent):void
		{
			TweenLite.to(this, 0.3, {alpha:1});
			
		}
		
		protected function handleRollOut(event:MouseEvent):void
		{
			TweenLite.to(this, 0.3, {alpha:defaultAlpha});
		}
		
		
		public function set tooltip(value:String):void
		{
			_tooltip = value;
			
			var format:TextFormat = new TextFormat();
			format.font = EmbeddedFonts.UNI_05_53;
			format.color = 0xffffff;
			format.size = 8; 
			
			var bg:TooltipArrowBackground = new TooltipArrowBackground();
			
			var tip:Tooltip = Tooltips.createTip(this, value, Tooltip.POSITION_TOP, format, bg, 0, -1);
		}
		
		public function get tooltip():String
		{
			return _tooltip;
		}
		 
	}
}