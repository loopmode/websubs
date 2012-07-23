package org.mindpirates.video.subs.view
{
	import com.greensock.TweenLite;
	
	import de.loopmode.tooltips.Tooltip;
	import de.loopmode.tooltips.Tooltips;
	import de.loopmode.tooltips.backgrounds.TooltipArrowBackground;
	
	import embed.fonts.EmbeddedFonts;
	
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import fl.events.ListEvent;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	import org.mindpirates.video.subs.loading.SubtitleFileLoader;
	
	public class SubsComboBox extends ComboBox
	{ 
		private var format:TextFormat;
		private var label:TextField;
		private static const LABEL_STRING:String = "Subtitles: ";
		private var lastText:String;
		private var textUpdateTimer:Timer;
		private static const MAX_UPDATE_TIMER_STEPS:int = 10;
		private var tooltip:Sprite;
		private var hilightColor:uint = 0x259FE2;
		
		private var isOpened:Boolean = false;
		
		public function SubsComboBox()
		{ 
			super(); 
			
			format = new TextFormat()
			format.color = 0xFFFFFF; 
			format.font = EmbeddedFonts.UNI_05_53;
			format.size = 8;
			format.align = TextFormatAlign.RIGHT; 
			
			createLabel();
			
			addEventListener(Event.CHANGE, handleChange);
			addEventListener(MouseEvent.ROLL_OVER, handleRollOver);
			addEventListener(MouseEvent.ROLL_OUT, handleRollOut);
			
			
			addEventListener(ListEvent.ITEM_ROLL_OVER, handleItemRollOver);
			addEventListener(ListEvent.ITEM_ROLL_OUT, handleItemRollOut);
			addEventListener(Event.OPEN, handleOpen);
			
			var ttformat:TextFormat = new TextFormat();
			ttformat.font = EmbeddedFonts.UNI_05_53;
			ttformat.color = 0xffffff;
			ttformat.size = 8; 
			Tooltips.createTip(this, 'Choose subtitle language', Tooltip.POSITION_TOP, ttformat,  new TooltipArrowBackground, 0, -1);
			 
		}
		 
		protected function handleOpen(event:Event):void
		{
			isOpened = true;
			Tooltips.hideTip(this);
		}		
		
		protected function handleItemRollOver(event:ListEvent):void
		{ 
			removeTooltip(); 
			var selectedItem:Object = dataProvider.getItemAt(Number(event.rowIndex.toString()));
			if(selectedItem && selectedItem.description) {
				tooltip = createTooltip(selectedItem.description); 
				tooltip.x = event.target.x + event.target.width + 7;
				tooltip.y = parent.mouseY;
			}
		}
		protected function handleItemRollOut(event:ListEvent):void
		{
			removeTooltip();			
		}
		
		protected function handleRollOver(event:MouseEvent):void
		{
			label.backgroundColor = hilightColor;
		}
		
		protected function handleRollOut(event:MouseEvent):void
		{
			label.backgroundColor = 0x111A19;
			
		}
		
		/*
		-------------------------------------------------------------
		
		TOOLTIP
		
		-------------------------------------------------------------
		*/
		
		private function createTooltip(text:String):Sprite
		{
			
			var tt:Sprite = new Sprite();
			
			var pad:Number = 3;
			var extraW:Number = 2;
			var extraH:Number = 3;
			var triHeight:Number = 7;
			var triWidth:Number = 7;
			var tf:TextField = new TextField();
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.embedFonts = true;
			var tformat:TextFormat = new TextFormat();
			tformat.font = EmbeddedFonts.UNI_05_53;
			tformat.color = 0xffffff;
			tformat.size = 8;
			tf.defaultTextFormat = tformat;
			tf.text = text;
			tf.x = int(pad);
			tf.y = int(pad);
			
			var w:Number = tf.textWidth+pad*2+extraW
			var h:Number = tf.textHeight+pad*2+extraH;
			var g:Graphics = tt.graphics;
			g.clear(); 
			g.beginFill(hilightColor, 0.95);
			g.drawRoundRect(0,0,w,h,10,10);
			g.moveTo(0, h/2 - triHeight/2);
			g.lineTo(-triWidth, h/2);
			g.lineTo(0, h/2 + triHeight/2);
			g.endFill();
			
			tt.alpha = 0;
			tt.addChild(tf);
			tt.filters = [new DropShadowFilter(4,45,0,0.5)];
			parent.addChild(tt); 
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, handleTooltipMouseMove, false, 0, true); 
			
			//fadein
			var t:Timer = new Timer(1, 1);
			var fadein:Function = function(e:TimerEvent):void {
				t.removeEventListener(TimerEvent.TIMER_COMPLETE, fadein);
				if (tt) {
					TweenLite.to(tt, 0.1, {alpha: 1});	
				}
			};
			t.addEventListener(TimerEvent.TIMER_COMPLETE, fadein, false, 0, true);
			t.start();
			
			return tt;
		}
		
		private function handleTooltipMouseMove(e:MouseEvent):void
		{
			if (tooltip) {
				tooltip.x = int(x + width + 7);
				tooltip.y = int(y - (height*(dataProvider.length)) +  e.target.y);
			}
		} 
		
		private function removeTooltip():void
		{
			try {
				tooltip.parent.removeChild(tooltip);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleTooltipMouseMove);
			}
			catch (err:Error) {
				
			}
			tooltip = null;
		}
		
		
		
		
		
		private function createLabel():void
		{
			label = new TextField();
			label.embedFonts = true;
			label.selectable = false;
			label.multiline = false;
			label.mouseEnabled = false;
			label.autoSize = TextFieldAutoSize.LEFT; 
			label.background = true;
			label.backgroundColor = 0x111A19;
			label.x = 4; 
			label.defaultTextFormat = format;
			var labelFormat:TextFormat = label.defaultTextFormat;
			labelFormat.align = TextFormatAlign.LEFT;
			label.defaultTextFormat = format;
			label.text = LABEL_STRING; 
			addChild(label);
		}			 
	 
		override protected function drawList():void
		{
			super.drawList(); 
			rowCount = dataProvider.length;
			dropdown.setRendererStyle("embedFonts", true);
			dropdown.setRendererStyle("textFormat", format); 
		}
		
		override protected function drawTextField():void 
		{ 
			super.drawTextField(); 
			textField.setStyle("embedFonts", true); 
			textField.setStyle("textFormat", format); 
			textField.y = 0; 
			textField.x = 7; 
		}
	 
		
		
		
		
		protected function handleChange(event:Event):void
		{ 
			if (textUpdateTimer) {
				destroyUpdateTimer();
			}  
			createUpdateTimer();
		}	
		
		
		private function createUpdateTimer():void
		{
			textUpdateTimer = new Timer(1);
			textUpdateTimer.addEventListener(TimerEvent.TIMER, handleUpdateTimer);
			textUpdateTimer.start();
		}
		
		private function destroyUpdateTimer():void
		{
			textUpdateTimer.removeEventListener(TimerEvent.TIMER, handleUpdateTimer);
			textUpdateTimer.stop();
			textUpdateTimer = null;
		}
		
		protected function handleUpdateTimer(event:TimerEvent):void
		{ 
			if ((textField.text != lastText && textField.textWidth > 0) || textUpdateTimer.currentCount > MAX_UPDATE_TIMER_STEPS) {  
				destroyUpdateTimer();
				onTextfieldChanged();
			} 
		}
		
		private function onTextfieldChanged():void
		{  
			lastText = textField.text; 
			TweenLite.to(this, 0.3, { 
				width: label.x + label.textWidth + textField.textWidth + 26,
				onUpdate: function():void {
					drawTextField();
					dispatchEvent(new Event(Event.RESIZE));
				}
			});
			
		}
		
		public function showSpinner():void
		{
			
		}
		
		
		
		
		override public function set dataProvider(arg0:DataProvider):void
		{
			super.dataProvider = arg0;
			selectedIndex = 0;
			drawList();
			drawTextField();
			handleChange(null);
		}
		
		override public function set selectedIndex(arg0:int):void
		{
			super.selectedIndex = arg0;
			handleChange(null);
		}
		
		public function createDataProvider(files:Vector.<SubtitleFileLoader>):DataProvider
		{
			var dp:Array = [];
			for each (var file:SubtitleFileLoader in files) {
				dp.push({
					label: file.title,
					title: file.title,
					fileLoader: file,
					description: file.description
				}); 
			}
			return new DataProvider(dp);
		}
		
		
		/**
		 * Returns the index of an item based on the fileLoader reference.
		 * @param fileLoader The fileLoader of the searched list item.
		 * @return The index of the item within the dataProvider or -1 if no match was found.
		 */ 
		public function getFileIndex(fileLoader:SubtitleFileLoader):int
		{ 
			var i:int = 0;
			while (i<dataProvider.length) {
				if (dataProvider.getItemAt(i).fileLoader == fileLoader) {
					return i;
				}
				i++;
			}
			return -1;
		}
	}
}