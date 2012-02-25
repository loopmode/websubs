package org.mindpirates.video.subs.view
{
	import com.greensock.TweenLite;
	
	import embed.fonts.EmbeddedFonts;
	
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
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
			
		}
		
		protected function handleRollOver(event:MouseEvent):void
		{
			label.backgroundColor = 0x259FE2;
		}
		
		protected function handleRollOut(event:MouseEvent):void
		{
			label.backgroundColor = 0x111A19;
			
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
					fileLoader: file
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